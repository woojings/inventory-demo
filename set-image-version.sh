#!/bin/bash
sed -i "s/\(image: 855607364597.dkr.ecr.ap-northeast-2.amazonaws.com\/inventory\):.*$/\1:${BUILD_NUMBER}/" inventory-dep.yaml
