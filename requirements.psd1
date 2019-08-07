@{
    psake             = @{
        Name           = 'psake'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
        Target         = 'CurrentUser'
        Version        = '4.7.4'
        Tags           = 'Bootstrap'
    }

    Pester            = @{
        Name           = 'Pester'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
        Target         = 'CurrentUser'
        Version        = '4.7.3'
        Tags           = 'Test'
    }

    PSScriptAnalyzer  = @{
        Name           = 'PSScriptAnalyzer'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
        Target         = 'CurrentUser'
        Version        = '1.18.0'
        Tags           = 'Test'
    }

    BuildHelpers      = @{
        Name           = 'BuildHelpers'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
        Target         = 'CurrentUser'
        Version        = '2.0.10'
        Tags           = 'Init'
    }

    Platyps           = @{
        Name           = 'Platyps'
        DependencyType = 'PSGalleryModule'
        Parameters     = @{
            Repository         = 'PSGallery'
            SkipPublisherCheck = $true
        }
        Target         = 'CurrentUser'
        Version        = '0.14.0'
        Tags           = 'Build'
    }
}
