# To start minikube, run
minikube start --driver=docker

# in order to map the local folder to pv
minikube mount /mnt/data/k8s:/mnt/data/k8s

note: a terminal is required to keep open in order to map the host folder and minikube pv

this should not trigger python 123


name: Github Action/CICD Pipeline
on: [push]

env:
  working-directory: src
  SOURCE_URL: 'https://nuget.pkg.github.com/sede-x/index.json'
  IMAGE_NAME: seau_tns_flex_marketdata_loader
  AZURE_CR_DEV: seaupowerteamdev.azurecr.io
  AZURE_CR_UAT: seaupowerteamuat.azurecr.io

jobs:

# Build and Test
  build:
    name: Build and Test
    runs-on: ubuntu-latest

    strategy:
      matrix:
        dotnet-version: [ '8.0']
    
    defaults:
      run:
        working-directory: ${{ env.working-directory }}

    steps:
      - name: Setup dotnet ${{ matrix.dotnet-version }}
        uses: actions/setup-dotnet@v1
        with:
          dotnet-version: ${{ matrix.dotnet-version }}

      - name: Checkout Code
        uses: actions/checkout@v2
        with:
          ref: ${{ github.head_ref }}   # checkout the correct branch name
          fetch-depth: 0   
      
      - name: Add Nuget Source
        run: |
          dotnet nuget add source --username USERNAME --password ${{ secrets.GITHUB_TOKEN }} --store-password-in-clear-text --name github ${{ env.SOURCE_URL }}

      - name: Run build
        run: |
          dotnet build --configuration Release
 
# Publish new image to ACR-DEV
  Publish-Dev:
    name: Publish new image to ACR-DEV
    needs: [ build ]
    runs-on: ubuntu-latest
    strategy:
      matrix:
        dotnet-version: [ '8.0']
    defaults:
      run:
        working-directory: ${{ env.working-directory }}
    steps:
      - name: Setup dotnet ${{ matrix.dotnet-version }}
        uses: actions/setup-dotnet@v1
        with:
          dotnet-version: ${{ matrix.dotnet-version }}

      - name: Checkout Code
        uses: actions/checkout@v2
        with:
          ref: ${{ github.head_ref }}
          fetch-depth: 0   
      
      - name: Add Nuget Source
        run: |
          dotnet nuget add source --username USERNAME --password ${{ secrets.GITHUB_TOKEN }} --store-password-in-clear-text --name github ${{ env.SOURCE_URL }}

      - name: Log in to dev ACR
        uses: docker/login-action@v2
        with:
          registry: ${{ env.AZURE_CR_DEV }}
          username: ${{ secrets.ACR_USER_DEV }}
          password: ${{ secrets.ACR_TOKEN_DEV }}

      - name: ACR - Build and push Docker image
        working-directory: ${{ env.working-directory }}
        run: |
          cd ../artifacts/deploy
          bash build.sh ${{ env.IMAGE_NAME}}
          
          docker image tag ${{ env.IMAGE_NAME}} ${{ env.AZURE_CR_DEV }}/sede-x/${{ env.IMAGE_NAME}}:dev-${{github.run_number}}
          docker image push ${{ env.AZURE_CR_DEV }}/sede-x/${{ env.IMAGE_NAME}}:dev-${{github.run_number}}

          docker image tag ${{ env.IMAGE_NAME}} ${{ env.AZURE_CR_DEV }}/sede-x/${{ env.IMAGE_NAME}}:latest
          docker image push ${{ env.AZURE_CR_DEV }}/sede-x/${{ env.IMAGE_NAME}}:latest

# Publish new image to ACR-DEV
  Publish-Uat-Dev:
    name: Publish new image to ACR-UAT-DEV
    needs: [ build ]
    if: ${{ github.ref != 'refs/heads/main' }}
    runs-on: ubuntu-latest
    strategy:
      matrix:
        dotnet-version: [ '8.0']
    defaults:
      run:
        working-directory: ${{ env.working-directory }}
    steps:
      - name: Setup dotnet ${{ matrix.dotnet-version }}
        uses: actions/setup-dotnet@v1
        with:
          dotnet-version: ${{ matrix.dotnet-version }}

      - name: Checkout Code
        uses: actions/checkout@v2
        with:
          ref: ${{ github.head_ref }}
          fetch-depth: 0   
      
      - name: Add Nuget Source
        run: |
          dotnet nuget add source --username USERNAME --password ${{ secrets.GITHUB_TOKEN }} --store-password-in-clear-text --name github ${{ env.SOURCE_URL }}

      - name: Log in to uat ACR
        uses: docker/login-action@v2
        with:
          registry: ${{ env.AZURE_CR_UAT }}
          username: ${{ secrets.ACR_USER_UAT }}
          password: ${{ secrets.ACR_TOKEN_UAT }}

      - name: ACR - Build and push Docker image
        working-directory: ${{ env.working-directory }}
        run: |
          cd ../artifacts/deploy
          bash build.sh ${{ env.IMAGE_NAME}}
          
          docker image tag ${{ env.IMAGE_NAME}} ${{ env.AZURE_CR_UAT }}/sede-x/${{ env.IMAGE_NAME}}:dev-${{github.run_number}}
          docker image push ${{ env.AZURE_CR_UAT }}/sede-x/${{ env.IMAGE_NAME}}:dev-${{github.run_number}}

# Get GitVersion
  lint:
    runs-on: ubuntu-latest
    needs: build
    if: ${{ github.ref == 'refs/heads/main' }}
    outputs:
      semVer: ${{ steps.version.outputs.new-version }}
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3
        with:
          ref: ${{ github.head_ref }}   # checkout the correct branch name
          fetch-depth: 0                # fetch the whole repo history

      # Get the existing and next sematic version
      - name: Get Version
        id: version
        shell: bash
        run: |
          export VERSION=$(docker run -v $(pwd):/repo codacy/git-version /bin/git-version \
            --folder /repo \
            --release-branch main)

          echo "::set-output name=new-version::$VERSION"
          echo "New Version: $VERSION"
      
      # Create a release and tag in github
      - name: Create Release
        id: create_release
        uses: actions/create-release@v1
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }} 
        with:
          tag_name: ${{ steps.version.outputs.new-version }}
          release_name: Release ${{ steps.version.outputs.new-version }}
          body: |
            Changes in this Release
            - First Change Place Holder
            - Second Change Placeholder
          draft: false
          prerelease: false

# Publish new image to ACR-UAT
  Publish-Uat:
    name: Publish new image to ACR-UAT
    needs: [ lint ]
    runs-on: ubuntu-latest
    if: ${{ github.ref == 'refs/heads/main' }}
    env:
      SEMVER: ${{ needs.lint.outputs.semVer }}
    strategy:
      matrix:
        dotnet-version: [ '8.0']
    defaults:
      run:
        working-directory: ${{ env.working-directory }}
    steps:
      - name: Display Semantic Version
        working-directory: ./
        run: |
            echo SemVer: $SEMVER

      - name: Setup dotnet ${{ matrix.dotnet-version }}
        uses: actions/setup-dotnet@v1
        with:
          dotnet-version: ${{ matrix.dotnet-version }}

      - name: Checkout Code
        uses: actions/checkout@v2
        with:
          ref: ${{ github.head_ref }} 
          fetch-depth: 0   
      
      - name: Add Nuget Source
        run: |
          dotnet nuget add source --username USERNAME --password ${{ secrets.GITHUB_TOKEN }} --store-password-in-clear-text --name github ${{ env.SOURCE_URL }}

      - name: Azure ACR - Log in to the Container registry
        uses: docker/login-action@f054a8b539a109f9f41c372932f1ae047eff08c9
        with:
          registry: ${{ env.AZURE_CR_UAT }}
          username: ${{ secrets.ACR_USER_UAT }}
          password: ${{ secrets.ACR_TOKEN_UAT }}
    
      - name: ACR - Build and push Docker image
        run: |
          cd ../artifacts/deploy
          bash build.sh ${{ env.IMAGE_NAME}}
    
          docker image tag ${{ env.IMAGE_NAME}} ${{ env.AZURE_CR_UAT }}/sede-x/${{ env.IMAGE_NAME}}:${{env.SEMVER}}
          docker image push ${{ env.AZURE_CR_UAT }}/sede-x/${{ env.IMAGE_NAME}}:${{env.SEMVER}}
    
          docker image tag ${{ env.IMAGE_NAME}} ${{ env.AZURE_CR_UAT }}/sede-x/${{ env.IMAGE_NAME}}:latest
          docker image push ${{ env.AZURE_CR_UAT }}/sede-x/${{ env.IMAGE_NAME}}:latest

