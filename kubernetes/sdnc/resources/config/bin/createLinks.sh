#!/bin/sh

###
# ============LICENSE_START=======================================================
# ONAP : SDN-C
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================
###


if [ "$MDSAL_PATH" = "" ]
then
    MDSAL_PATH=/opt/opendaylight/mdsal
fi

if [ "$JOURNAL_PATH" = "" ]
then
    JOURNAL_PATH=/opt/opendaylight/journal
fi

if [ "$SNAPSHOTS_PATH" = "" ]
then
    SNAPSHOTS_PATH=/opt/opendaylight/snapshots
fi

if [ ! -L $JOURNAL_PATH ]
then
    if [ -d $JOURNAL_PATH ]
    then
        mv $JOURNAL_PATH/* $MDSAL_PATH/journal
        rm -f $JOURNAL_PATH
    fi
    ln -s $MDSAL_PATH/journal $JOURNAL_PATH
fi

if [ ! -L $SNAPSHOTS_PATH ]
then
    if [ -d $SNAPSHOTS_PATH ]
    then
        mv $SNAPSHOTS_PATH/* $MDSAL_PATH/snapshots
        rm -f $SNAPSHOTS_PATH
    fi
    ln -s $MDSAL_PATH/snapshots $SNAPSHOTS_PATH
fi
