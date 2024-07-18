  version: 0.2
  env:
    shell: bash
    secrets-manager:
      GITHUB_TOKEN: GITHUB_TOKEN:GITHUB_TOKEN
  phases:
    install:
      runtime-versions: 
        nodejs: 20
    pre_build:
      on-failure: ABORT
      commands:
      - echo 'Start pre build phase'
      - export REPO_NAME=$(jq -r '.repo_name' metadata.json)
      - export BRANCH_NAME=$(jq -r '.branch_name' metadata.json)
      - export COMMIT_HASH=$(jq -r '.commit_id' metadata.json)
      - mkdir working_dir && cd working_dir
      - git clone https://oauth2:$GITHUB_TOKEN@github.com/$REPO_NAME .
      - git checkout $BRANCH_NAME
    build:
      commands:
      - ls -la
      - pwd
      #- aws ssm get-parameter --with-decryption --name /$${ENV}-$${PROJECT}-fe --region $${AWS_REGION} | jq -r '.Parameter.Value' > .env
      - aws secretsmanager get-secret-value --secret-id sotatek/ecs/dev/frontend --region us-east-1 | jq -r '.SecretString' | jq -r "to_entries|map(\"\(.key)=\\\"\(.value|tostring)\\\"\")|.[]" > .env
      - cat .env
      - yarn install
      - yarn build
      - echo "----------SYNC FILE TO S3 BUCKET----------------"
      - aws s3 sync ./dist s3://sotatek-ecs-frontend
      - echo "----------CLEAR CACHE CLOUDFRONT----------------"
      - DISTRIBUTION_ID=$(aws cloudfront list-distributions --query "DistributionList.Items[?Aliases.Items[0]=='aws.hugotech.online'].Id" --output text)
      - aws cloudfront create-invalidation --distribution-id $DISTRIBUTION_ID --paths "/*"