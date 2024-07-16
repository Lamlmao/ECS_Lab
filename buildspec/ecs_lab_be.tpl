  version: 0.2
  env:
    shell: bash
    secrets-manager:
      GITHUB_TOKEN: GITHUB_TOKEN:GITHUB_TOKEN
  phases:
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
      - echo Logging in to Amazon ECR...
      - aws --version
      - aws ecr get-login-password --region $${AWS_REGION} | docker login --username AWS --password-stdin $${ACCOUNT_ID}.dkr.ecr.$${AWS_REGION}.amazonaws.com
      - export IMAGE_TAG="$${COMMIT_HASH}"
      - export REPOSITORY_URI=$${ACCOUNT_ID}.dkr.ecr.$${AWS_REGION}.amazonaws.com/staging-egg3-backend
      - echo "REPOSITORY_URI $REPOSITORY_URI"
      - docker pull $REPOSITORY_URI:latest || true
    build:
      commands:
      - ls -la
      - echo Build started on `date` at commitID $${COMMIT_HASH}
      - echo Adding ENV, config ...
      #- aws ssm get-parameter --with-decryption --name /$${ENV}-$${PROJECT}-be --region $${AWS_REGION} | jq -r '.Parameter.Value' > .env
      - aws secretsmanager get-secret-value --secret-id sotatek/ecs/dev/backend --region us-east-1 | jq -r '.SecretString' | jq -r "to_entries|map(\"\(.key)=\\\"\(.value|tostring)\\\"\")|.[]" > .env
      - cat .env
      - echo Building the Docker image... $REPOSITORY_URI:$IMAGE_TAG
      - docker build --cache-from $REPOSITORY_URI:latest -t $REPOSITORY_URI:latest -f Dockerfile .
      - docker tag $REPOSITORY_URI:latest $REPOSITORY_URI:$IMAGE_TAG
    post_build:
      commands:
      - echo Build completed on `date`
      - echo pushing to repo
      - docker push $REPOSITORY_URI:latest
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo Writing image definitions file with IMAGE_TAG $IMAGE_TAG
      - printf '[{"name":"ecs-backend-service","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > $${ENV}-$${SERVICE}-artifact.json
      - ls -la
  artifacts:
    files: 'working_dir/$${ENV}-$${SERVICE}-artifact.json' 