@{
    PSDependOptions     = @{
        AddToPath  = $true
        Target     = 'output\RequiredModules'
        Parameters = @{
            Repository = ''
        }
    }
    invokeBuild         = 'latest'
    PSScriptAnalyzer    = 'latest'
    Pester              = '4.10.1'
    Plaster             = 'latest'
    Platyps             = 'latest'
    ModuleBuilder       = 'latest'
    ChangelogManagement = 'latest'
    Sampler             = '0.106.0-preview0005'
    MarkdownLinkCheck   = 'latest'
}
