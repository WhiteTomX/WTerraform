@{
    Rules = @{
        PSUseCompatibleCommmands = @{
            Enable = $true
            TargetProfiles = @(
                'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework' # 3.0 Windows Server 2012
                'win-8_x64_6.3.9600.0_4.0_x64_4.0.30319.42000_framework' # 4.0 Windows Server 2012R2
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework' # 5.1 Windows Server 2016
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # 5.1 Windows Server 2019
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # 5.1 Windows 10
            )
            TargetedVersions = @(
                "3.0",
                "4.0",
                "5.1"
            )
        }
        PSUseCompatibleTypes = @{
            Enable = $true
            TargetProfiles = @(
                'win-8_x64_6.2.9200.0_3.0_x64_4.0.30319.42000_framework' # 3.0 Windows Server 2012
                'win-8_x64_6.3.9600.0_4.0_x64_4.0.30319.42000_framework' # 4.0 Windows Server 2012R2
                'win-8_x64_10.0.14393.0_5.1.14393.2791_x64_4.0.30319.42000_framework' # 5.1 Windows Server 2016
                'win-8_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # 5.1 Windows Server 2019
                'win-48_x64_10.0.17763.0_5.1.17763.316_x64_4.0.30319.42000_framework' # 5.1 Windows 10
            )
        }
    }
}
