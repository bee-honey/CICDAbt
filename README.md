# CICDAbt

CICDAbt is a simple "Hello World" iOS application built with SwiftUI, primarily developed to demonstrate and test CI/CD workflows with the companion project, [GoGithub](https://github.com/bee-honey/GoGithub). GoGithub provides a dashboard to view recent commits, check workflow statuses, and trigger GitHub Actions workflows directly.

## Features
- **GitHub Actions Integration**: CICDAbt uses GitHub Actions for CI/CD. It includes automated build, archive, and IPA artifact upload steps.
- **Workflows**: CICDAbt includes two main workflows:
  - **iOS Starter Workflow**: Automatically triggered with every commit.
    - Builds and archives the iOS app.
    - Creates an IPA file, which is then uploaded as an artifact to GitHub.
  - **Release and Post Release Workflow**: Manually triggered for specific commits.
    - Fetches the IPA file from the artifact repository based on a specified commit SHA.
    - Installs required Fastlane dependencies and uploads the IPA to App Store Connect.
    - Automatically increments the build number after a successful upload, preparing for the next release.
- **Automated Build Number Increment**: Fastlane handles automatic build number incrementation.
- **Automated Git Commit**: A dedicated bot account is used to push the updated build number to the repository after each release.

## Setup

### Prerequisites
- **Xcode**: Ensure Xcode is installed to build and archive the iOS app.
- **Fastlane**: Required for automating App Store uploads and version management.
- **App Store Connect API**: Create an App Store Connect API key for secure, automated uploads.
- **Distribution Provisioning Profiles**: Ensure valid provisioning profiles for distribution.
- **P12 Certificates**: Necessary for App Store authentication and distribution.

### Parameters
The following parameters are essential for running and configuring the workflows:

| Parameter                | Description                                            | Example                        |
|--------------------------|--------------------------------------------------------|--------------------------------|
| `repoOwner`              | Owner of the GitHub repository                         | `"bee-honey"`                  |
| `repoName`               | Name of the GitHub repository                          | `"CICDAbt"`                    |
| `workflowFile`           | GitHub Actions workflow file (e.g., release.yml)       | `"release.yml"`                |
| `GITHUB_TOKEN`           | GitHub Personal Access Token for API access            | `"your_personal_token"`        |
| `AppStore_Connect_Key`   | Key for App Store Connect API integration              | `"your_app_store_key"`         |
| `Provisioning Profiles`  | Distribution profiles for building and archiving       | `"path/to/profiles.mobileprovision"` |
| `P12 Certificates`       | Certificates for App Store distribution                | `"path/to/certificates.p12"`   |

### Installation and Running the Application

1. **Clone the Repository**
   ```bash
   git clone https://github.com/yourusername/CICDAbt.git
   cd CICDAbt
