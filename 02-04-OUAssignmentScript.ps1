# Define the OU details
$ouStructure = @{
    "InfraIT_Users" = @(
        "Finance",
        "Sales",
        "IT",
        "Consultants",
        "HR"
    )
    "InfraIT_Computers" = @{
        "Workstations" = @(
            "Finance", 
            "Sales",
            "IT",
            "Consultants",
            "HR"
        ),
        "Servers"
    }
    "InfraIT_Groups" = @(
        "Global",
        "Local"
    )
}

$domainPath = "DC=InfraIT,DC=sec"

# Create all OUs
foreach ($parentOU in $ouStructure.Keys) {
    # Create parent OU
    $parentPath = $domainPath
    Write-Host "`nCreating parent OU: $parentOU" -ForegroundColor Cyan
    $parentCreated = New-CustomADOU -Name $parentOU -Path $parentPath
    
    if ($parentCreated) {
        # Verify parent OU exists before creating children
        $parentFullPath = "OU=$parentOU,$domainPath"
        $verifyParent = Get-ADOrganizationalUnit -Identity $parentFullPath -ErrorAction SilentlyContinue
        
        if ($verifyParent) {
            Write-Host "Verified parent OU exists, creating children..." -ForegroundColor Cyan
            # Create child OUs
            foreach ($childOU in $ouStructure[$parentOU]) {
                $childPath = $parentFullPath
                New-CustomADOU -Name $childOU -Path $childPath
            }
        } else {
            Write-Host "Parent OU verification failed for: $parentOU" -ForegroundColor Red
            Write-Host "Cannot create child OUs" -ForegroundColor Red
        }
    }
}