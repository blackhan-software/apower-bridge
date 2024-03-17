#!/usr/bin/env bash
source .env
cast call --rpc-url apow \
    $APOW_CALCULATOR "result()(uint256)" ;
