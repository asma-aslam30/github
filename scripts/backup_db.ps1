# # backup_db.ps1

# # Load .env file (crawl_start.py ke folder me hai)
# $envFile = "$PSScriptRoot\..\crawler\.env"
# if (Test-Path $envFile) {
#     Get-Content $envFile | ForEach-Object {
#         if ($_ -match "^\s*([^#=]+)\s*=\s*(.+)\s*$") {
#             [Environment]::SetEnvironmentVariable($matches[1], $matches[2])
#         }
#     }
# }

# # Use environment variables
# $DB_USER = $env:DB_USER
# $DB_PASSWORD = $env:DB_PASSWORD
# $DB_NAME = $env:DB_NAME

# # Backup folder
# $BackupFolder = "$PSScriptRoot\backups"
# if (!(Test-Path $BackupFolder)) {
#     New-Item -ItemType Directory -Path $BackupFolder
# }

# # Timestamped backup filename
# $Date = Get-Date -Format "yyyyMMdd_HHmmss"
# $BackupFile = "$BackupFolder\$DB_NAME`_backup_$Date.sql"

# # Set password for pg_dump
# $env:PGPASSWORD = $DB_PASSWORD

# # Run pg_dump
# Write-Output "Backing up database $DB_NAME..."
# pg_dump -U $DB_USER -F c -b -v -f $BackupFile $DB_NAME

# Write-Output "Backup saved to $BackupFile"

# # Commit and push the backup to GitHub
# git add $BackupFolder
# git commit -m "Local DB Backup: $DB_NAME - $Date" || Write-Output "No changes to commit"
# git push




 Load .env file (crawl_stars.py ke folder me hai)
$envFile = "$PSScriptRoot\..\crawler\.env"
if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#=]+)\s*=\s*(.+)\s*$") {
            [Environment]::SetEnvironmentVariable($matches[1], $matches[2])
        }
    }
}

# Use environment variables for main database
$DB_USER = $env:DB_USER
$DB_PASSWORD = $env:DB_PASSWORD
$DB_NAME = $env:DB_NAME
$DB_HOST = $env:DB_HOST

# Use environment variables for shard databases
$DB_NAME_SHARDS = @($env:DB_NAME_1, $env:DB_NAME_2) | Where-Object { $_ }  # Filter out empty values

# Backup folder
$BackupFolder = "$PSScriptRoot\backups"
if (!(Test-Path $BackupFolder)) {
    New-Item -ItemType Directory -Path $BackupFolder
}

# Timestamp for backup filenames
$Date = Get-Date -Format "yyyyMMdd_HHmmss"

# Set password for pg_dump
$env:PGPASSWORD = $DB_PASSWORD

# Function to backup a single database
function Backup-Database {
    param (
        [string]$DbName,
        [string]$BackupFolder,
        [string]$Date,
        [string]$DbUser,
        [string]$DbHost
    )
    $BackupFile = "$BackupFolder\${DbName}_backup_$Date.sql"
    Write-Output "Backing up database $DbName..."
    pg_dump -U $DbUser -h $DbHost -F c -b -v -f $BackupFile $DbName
    if ($LASTEXITCODE -eq 0) {
        Write-Output "Backup saved to $BackupFile"
    } else {
        Write-Output "Error backing up database $DbName"
    }
    return $BackupFile
}

# Backup main database
$BackupFiles = @()
if ($DB_NAME) {
    $BackupFiles += Backup-Database -DbName $DB_NAME -BackupFolder $BackupFolder -Date $Date -DbUser $DB_USER -DbHost $DB_HOST
}

# Backup shard databases
foreach ($shard in $DB_NAME_SHARDS) {
    $BackupFiles += Backup-Database -DbName $shard -BackupFolder $BackupFolder -Date $Date -DbUser $DB_USER -DbHost $DB_HOST
}

# Commit and push all backups to GitHub
if ($BackupFiles) {
    git add $BackupFolder
    git commit -m "Local DB Backups: $DB_NAME, $($DB_NAME_SHARDS -join ', ') - $Date" || Write-Output "No changes to commit"
    git push
} else {
    Write-Output "No backups created, skipping git commit"
}