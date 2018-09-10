{{/*
# Copyright © 2017 Amdocs, Bell Canada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}

{{/*
  If storageClassName is defined at the child level, use that (allow override). StorageClassName is typically not set for components. 
  Else use the global setting.
  Note: with current logic, having it set to "" or "-" will override global.
   default DEFAULT_VALUE GIVEN_VALUE
  TODO: what happens when both global and local are undefined? storageClassName shouldn't be set in chart...
*/}}
{{- define "common.persistence.storageClass" -}}
  {{- default .Values.global.persistence.storageClass .Values.persistence.storageClass -}}
{{- end -}}

