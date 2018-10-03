/*
 * ============LICENSE_START===================================================
 * Copyright (c) 2018 Amdocs
 * ============================================================================
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============LICENSE_END=====================================================
 */

entity {
    name 'POA-EVENT'
    indexing {
        indices 'default-rules'
    }
  validation {

    // NDCB-AAI comparison: Context level
    useRule {
      name 'NDCB-AAI-attribute-comparison'
      attributes 'context-list.ndcb', 'context-list.aai'
    }

    // NDCB-AAI comparison: Service entity
    useRule {
      name 'NDCB-AAI-attribute-comparison'
      attributes 'context-list.ndcb.service', 'context-list.aai.service'
    }

    // NDCB-AAI comparison: VF list
    useRule {
      name 'NDCB-AAI-attribute-comparison'
      attributes 'context-list.ndcb.vfList[*]', 'context-list.aai.vfList[*]'
    }

    // NDCB-AAI comparison: VF-Module list
    useRule {
      name 'NDCB-AAI-attribute-comparison'
      attributes 'context-list.ndcb.vfList[*].vfModuleList[*]', 'context-list.aai.vfList[*].vfModuleList[*]'
    }

    // NDCB-AAI comparison: VNFC list
    useRule {
      name 'NDCB-AAI-attribute-comparison'
      attributes 'context-list.ndcb.vfList[*].vnfcList[*]', 'context-list.aai.vfList[*].vnfcList[*]'
    }

    // NDCB-AAI comparison: VM list
    useRule {
      name 'NDCB-AAI-attribute-comparison'
      attributes 'context-list.ndcb.vfList[*].vfModuleList[*].vmList[*]', 'context-list.aai.vfList[*].vfModuleList[*].vmList[*]'
    }

    // NDCB-AAI comparison: Network list
    useRule {
      name 'NDCB-AAI-attribute-comparison'
      attributes 'context-list.ndcb.vfList[*].vfModuleList[*].networkList[*]', 'context-list.aai.vfList[*].vfModuleList[*].networkList[*]'
    }

    // SDC-AAI VNFC type
    useRule {
      name 'SDC-AAI-vnfc-type'
      attributes 'context-list.sdc.vfList[*].vnfcList[*]', 'context-list.aai.vfList[*].vnfcList[*]'
    }

    // SDC-AAI VNFC node count
    useRule {
      name 'SDC-AAI-vnfc-node-count'
      attributes 'context-list.sdc.vfList[*].vnfcList[*]', 'context-list.aai.vfList[*].vnfcList[*]'
    }

    // SDC-AAI VF-Module instance
    useRule {
      name 'SDC-AAI-vf-module-instance-check'
      attributes 'context-list.ndcb.vfList[*].vfModuleList[*]', 'context-list.aai.vfList[*].vfModuleList[*]'
    }
  }
}

rule {
  name        'SDC-AAI-vnfc-type'
  category    'VNFC Consistency'
  description 'Validate that each VNFC instance in AAI conforms to a VNFC type defined in SDC model'
  errorText   'AAI VNFC instance includes non-specified type in design SDC model'
  severity    'ERROR'
  attributes  'sdcList', 'aaiList'
  validate    '''
        def getVnfcTypes = { parsedData ->
          parsedData.collect{ it.findResult{ k, v -> if(k.equals("type")) {return "$v"}}}
        }

        def slurper = new groovy.json.JsonSlurper()
        def sdcTypes = getVnfcTypes(slurper.parseText(sdcList.toString()))
        def aaiTypes = getVnfcTypes(slurper.parseText(aaiList.toString()))

        // each type in AAI must exist in SDC
        return sdcTypes.containsAll(aaiTypes)
                '''
}

rule {
  name        'SDC-AAI-vnfc-node-count'
  category    'VNFC Consistency'
  description 'Validate that for each VNFC node defined in SDC model, there is at least one VNFC instance in AAI'
  errorText   'Design has specified types but not all of them exist in AAI'
  severity    'WARNING'
  attributes  'sdcList', 'aaiList'
  validate    '''
        def getVnfcNodes = { parsedData ->
          parsedData.collect { new Tuple2(
              it.findResult{ k, v -> if(k.equals("name")) {return "$v"}},
              it.findResult{ k, v -> if(k.equals("type")) {return "$v"}})
          }
        }

        def slurper = new groovy.json.JsonSlurper()
        def sdcNodes = getVnfcNodes(slurper.parseText(sdcList.toString()))
        def aaiNodes = getVnfcNodes(slurper.parseText(aaiList.toString()))

        // each node in AAI must exist in SDC
        return aaiNodes.containsAll(sdcNodes)
                '''
}

rule {
  name        'SDC-AAI-vf-module-instance-check'
  category    'VF Consistency'
  description 'Validate that each VF module instance in AAI conforms to a VF module defined in SDC service model'
  errorText   'One or more AAI VF module instance(s) not defined in SDC model'
  severity    'CRITICAL'
  attributes  'sdcList', 'aaiList'
  validate    '''
        def getVfModules = { parsedData ->
          parsedData.collect{ it.findResult{ k, v -> if(k.equals("name")) {return "$v"}}}
        }

        def slurper = new groovy.json.JsonSlurper()
        def sdcVfModules = getVfModules(slurper.parseText(sdcList.toString()))
        def aaiVfModules = getVfModules(slurper.parseText(aaiList.toString()))

        // all VF modules in AAI must exist in SDC
        return aaiVfModules.containsAll(sdcVfModules)
                '''
}

rule {
  name        'NDCB-AAI-attribute-comparison'
  category    'Attribute Mismatch'
  description 'Verify that all attributes in Network-Discovery are the same as in AAI'
  errorText   'Error found with attribute "{0}"; value "{1}" does not exist in Network-Discovery'
  severity    'ERROR'
  attributes  'ndcbItems', 'aaiItems'
  validate    '''
        Closure<java.util.Map> getAttributes = { parsedData ->
          java.util.Map attributeMap = new java.util.HashMap()

          def isAttributeDataQualityOk = { attribute ->
            attribute.findResult{ k, v -> if(k.equals("dataQuality") ) {return v.get("status")}}.equals("ok")
          }

          def addToMap = { attrKey, attrValue ->
            java.util.Set values = attributeMap.get("$attrKey")
            if(values == null) {
              values = new java.util.HashSet()
              attributeMap.put("$attrKey", values)
            }
            values.add("$attrValue")
          }

          def addAttributeToMap = { attribute ->
            if(isAttributeDataQualityOk(attribute)) {
              String key, value
              attribute.each { k, v ->
                if(k.equals("name")) {key = "$v"}
                if(k.equals("value")) {value = "$v"}
              }
              addToMap("$key", "$value")
            }
          }

          def processKeyValue = { key, value ->
            if(value instanceof java.util.ArrayList) {
              if(key.equals("attributeList")) {
                value.each {
                  addAttributeToMap(it)
                }
              }
            } else if(!(value instanceof groovy.json.internal.LazyMap)) {
              // only add key-value attributes, skip the rest
              addToMap("$key", "$value")
            }
          }

          if(parsedData instanceof java.util.ArrayList) {
            parsedData.each {
              it.each { key, value -> processKeyValue(key, value) }
            }
          } else {
            parsedData.each { key, value -> processKeyValue(key, value) }
          }
          return attributeMap
        }

        def slurper = new groovy.json.JsonSlurper()
        java.util.Map ndcb = getAttributes(slurper.parseText(ndcbItems.toString()))
        java.util.Map aai = getAttributes(slurper.parseText(aaiItems.toString()))

        boolean result = true
        List<String> details = new ArrayList<>();
        ndcb.any{ ndcbKey, ndcbValueList ->
          def aaiValueList = aai.get("$ndcbKey")
          aaiValueList.each{ aaiValue ->
            if(!ndcbValueList.any{ it == "$aaiValue" }) {
              result = false
              details.add("$ndcbKey")
              details.add("$aaiValue")
            }
          }
          if(result == false) {
            // break out of 'any' loop
            return true
          }
        }
        return new Tuple2(result, details)
        '''
}