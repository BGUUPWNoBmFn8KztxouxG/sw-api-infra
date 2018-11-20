#!/bin/sh
set -ueo pipefail

export GREEN='\033[1;32m'
export NC='\033[0m'
export CHECK="√"
export M2_LOCAL_REPO=".m2"
export DIR=$( pwd )

M2_HOME="${HOME}/.m2"
M2_CACHE="${DIR}/maven"

[[ -d "${M2_CACHE}" && ! -d "${M2_HOME}" ]] && ln -s "${M2_CACHE}" "${M2_HOME}"
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo -e "${GREEN}${CHECK} Cache symlinked!${NC}"

mvn -f source/pom.xml install
echo -e "${GREEN}${CHECK} Artifact built successfully!${NC}"

mv ./source/target/pgr301-eksamen.jar ./docker/app.jar
mv ./source/Dockerfile ./docker/