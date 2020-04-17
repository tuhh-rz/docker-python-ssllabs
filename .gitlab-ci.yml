variables:
    CONTAINER_RELEASE_IMAGE: docker.rz.tu-harburg.de:5000/$CI_PROJECT_NAMESPACE/$CI_PROJECT_NAME
    LATEST_VERSION: 'LATEST'

.build_script_template:
  script: &build_script_definition
    - pwd
    - key="PythonSSLLabs ${VERSION}"

    - version=$(curl -s https://cgi.tu-harburg.de/~rztwww/Software/program_file.json | jq --arg KEY "$key" --raw-output '.[$KEY] | .version')
    - if [[ -z $version ]]; then exit 1; fi
    - version=$(echo $version | sed -e 's/%2B/+/g')

    # - download=$(curl -s https://cgi.tu-harburg.de/~rztwww/Software/program_file.json | jq --arg KEY "$key" --raw-output '.[$KEY] | .download')
    # - if [[ -z $download ]]; then exit 1; fi

    - sudo docker build --build-arg DOWNLOAD="${download}" --build-arg VERSION="${version}" --no-cache --pull -t "${CONTAINER_RELEASE_IMAGE}":"${VERSION}${VARIANT:+-$VARIANT}" "${VERSION}"/"${VARIANT}"

.build_before_script_template:
  before_script: &build_before_script_definition
    - pwd
    - git submodule update --init --recursive

.deploy_script_template:
  script: &deploy_script_definition
    - pwd
    - sudo docker push "${CONTAINER_RELEASE_IMAGE}":"${VERSION}${VARIANT:+-$VARIANT}"
    - if [ ! -z ${LATEST_VERSION} ] && [ "${LATEST_VERSION}" == "${VERSION}${VARIANT:+-$VARIANT}" ]; then sudo docker tag "${CONTAINER_RELEASE_IMAGE}":"${VERSION}${VARIANT:+-$VARIANT}" "${CONTAINER_RELEASE_IMAGE}:latest"; sudo docker push "${CONTAINER_RELEASE_IMAGE}:latest"; fi

.build_branches_script_template:
  script: &build_branches_script_definition
    - pwd
    - key="Linkchecker ${VERSION}"

    - version=$(curl -s https://cgi.tu-harburg.de/~rztwww/Software/program_file.json | jq --arg KEY "$key" --raw-output '.[$KEY] | .version')
    - if [[ -z $version ]]; then exit 1; fi
    - version=$(echo $version | sed -e 's/%2B/+/g')

    - download=$(curl -s https://cgi.tu-harburg.de/~rztwww/Software/program_file.json | jq --arg KEY "$key" --raw-output '.[$KEY] | .download')
    - if [[ -z $download ]]; then exit 1; fi

    - sudo docker build --build-arg DOWNLOAD="${download}" --build-arg VERSION="${version}" --pull -t "${CONTAINER_RELEASE_IMAGE}":"${VERSION}${VARIANT:+-$VARIANT}"_"${CI_COMMIT_REF_NAME}" "${VERSION}"/"${VARIANT}"

.build_branches_before_script_template:
  before_script: &build_branches_before_script_definition
    - pwd
    - git submodule update --init --recursive

.deploy_branches_script_template:
  script: &deploy_branches_script_definition
    - pwd
    - sudo docker push "${CONTAINER_RELEASE_IMAGE}":"${VERSION}${VARIANT:+-$VARIANT}"_"${CI_COMMIT_REF_NAME}"

stages:
  - build
  - deploy
  - build_siblings

build:latest:
  stage: build
  retry: 2
  only:
    - master
  tags:
    - build
  variables:
    VERSION: "LATEST"
    VARIANT: ""
  before_script: *build_before_script_definition
  script: *build_script_definition

deploy:latest:
  stage: deploy
  needs: ["build:latest"]
  tags:
    - deploy
  only:
    - master
  variables:
    VERSION: "LATEST"
    VARIANT: ""
  script: *deploy_script_definition

build:branches:latest:
  stage: build
  retry: 2
  only:
    - branches
  except:
    - master
  tags:
    - build
  variables:
    VERSION: "LATEST"
    VARIANT: ""
  before_script: *build_branches_before_script_definition
  script: *build_branches_script_definition

deploy:branches:latest:
  stage: deploy
  needs: ["build:branches:latest"]
  tags:
    - deploy
  only:
    - branches
  except:
    - master
  variables:
    VERSION: "LATEST"
    VARIANT: ""
  script: *deploy_branches_script_definition
