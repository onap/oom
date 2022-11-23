{{/*
#
# Copyright (C) 2022 Huawei Technologies Co., Ltd. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
*/}}

main_path="/home/uui"
echo @main_path@ $main_path

JAVA_PATH="$JAVA_HOME/bin/java"
JAVA_OPTS="-Xms50m -Xmx128m"
echo @JAVA_PATH@ $JAVA_PATH
echo @JAVA_OPTS@ $JAVA_OPTS

jar_path="$main_path/usecase-ui-intent-analysis.jar"
echo @jar_path@ $jar_path

echo "Starting usecase-ui-intent-analysis..."
$JAVA_PATH $JAVA_OPTS -classpath $jar_path -jar $jar_path $SPRING_OPTS
