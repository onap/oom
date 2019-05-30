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
      name 'Attribute-comparison'
      attributes 'context-list.ndcb', 'context-list.aai'
    }

    // NDCB-AAI comparison: Service entity
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.service', 'context-list.aai.service'
    }

    // NDCB-AAI comparison: Context level network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.networkList[*]', 'context-list.aai.networkList[*]'
    }
	
    // NDCB-AAI comparison: VNF list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.vnfList[*]', 'context-list.aai.vnfList[*]'
    }

    // NDCB-AAI comparison: VNF network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.vnfList[*].networkList[*]', 'context-list.aai.vnfList[*].networkList[*]'
    }
	
    // NDCB-AAI comparison: VF-Module list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.vnfList[*].vfModuleList[*]', 'context-list.aai.vnfList[*].vfModuleList[*]'
    }

    // NDCB-AAI comparison: VF-Module network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.vnfList[*].vfModuleList[*].networkList[*]', 'context-list.aai.vnfList[*].vfModuleList[*].networkList[*]'
    }

    // NDCB-AAI comparison: VNFC list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.vnfList[*].vnfcList[*]', 'context-list.aai.vnfList[*].vnfcList[*]'
    }

    // NDCB-AAI comparison: VM list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.vnfList[*].vfModuleList[*].vmList[*]', 'context-list.aai.vnfList[*].vfModuleList[*].vmList[*]'
    }

    // NDCB-AAI comparison: P-Interface list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.ndcb.pnfList[*].pInterfaceList[*]', 'context-list.aai.pnfList[*].pInterfaceList[*]'
    }
	
	
    // SDNC-AAI comparison: Context level
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc', 'context-list.aai'
    }

    // SDNC-AAI comparison: Service entity
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.service', 'context-list.aai.service'
    }

    // SDNC-AAI comparison: Context level network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.networkList[*]', 'context-list.aai.networkList[*]'
    }

    // SDNC-AAI comparison: VNF list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*]', 'context-list.aai.vnfList[*]'
    }

    // SDNC-AAI comparison: VNF network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].networkList[*]', 'context-list.aai.vnfList[*].networkList[*]'
    }

    // SDNC-AAI comparison: VF-Module list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].vfModuleList[*]', 'context-list.aai.vnfList[*].vfModuleList[*]'
    }

    // SDNC-AAI comparison: VF-Module network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].vfModuleList[*].networkList[*]', 'context-list.aai.vnfList[*].vfModuleList[*].networkList[*]'
    }

    // SDNC-AAI comparison: VNFC list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].vnfcList[*]', 'context-list.aai.vnfList[*].vnfcList[*]'
    }

    // SDNC-AAI comparison: VM list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].vfModuleList[*].vmList[*]', 'context-list.aai.vnfList[*].vfModuleList[*].vmList[*]'
    }

    // AAI-SDNC PNF name validation
    useRule {
      name 'AAI-SDNC-pnf-name-check'
      attributes 'context-list.aai.pnfList[*].name', 'context-list.sdnc.pnfList[*].name'
    }


    // SDNC-NDCB comparison: Context level
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc', 'context-list.ndcb'
    }

    // SDNC-NDCB comparison: Service entity
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.service', 'context-list.ndcb.service'
    }

    // SDNC-NDCB comparison: Context level network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.networkList[*]', 'context-list.ndcb.networkList[*]'
    }

    // SDNC-NDCB comparison: VNF list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*]', 'context-list.ndcb.vnfList[*]'
    }

    // SDNC-NDCB comparison: VNF network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].networkList[*]', 'context-list.ndcb.vnfList[*].networkList[*]'
    }

    // SDNC-NDCB comparison: VF-Module list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].vfModuleList[*]', 'context-list.ndcb.vnfList[*].vfModuleList[*]'
    }

    // SDNC-NDCB comparison: VF-Module network list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].vfModuleList[*].networkList[*]', 'context-list.ndcb.vnfList[*].vfModuleList[*].networkList[*]'
    }

    // SDNC-NDCB comparison: VNFC list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].vnfcList[*]', 'context-list.ndcb.vnfList[*].vnfcList[*]'
    }

    // SDNC-NDCB comparison: VM list
    useRule {
      name 'Attribute-comparison'
      attributes 'context-list.sdnc.vnfList[*].vfModuleList[*].vmList[*]', 'context-list.ndcb.vnfList[*].vfModuleList[*].vmList[*]'
    }

	
	
    // SDC-AAI VNFC type
    useRule {
      name 'SDC-AAI-vnfc-type'
      attributes 'context-list.sdc.vnfList[*].vnfcList[*]', 'context-list.aai.vnfList[*].vnfcList[*]'
    }

    // SDC-AAI VNFC node count
    useRule {
      name 'SDC-AAI-vnfc-node-count'
      attributes 'context-list.sdc.vnfList[*].vnfcList[*]', 'context-list.aai.vnfList[*].vnfcList[*]'
    }

    // SDC-AAI VF-Module instance
    useRule {
      name 'SDC-AAI-vf-module-instance-check'
      attributes 'context-list.sdc.vnfList[*].vfModuleList[*]', 'context-list.aai.vnfList[*].vfModuleList[*]'
    }

    useRule {
       name 'AAI-not-empty'
       attributes 'context-list.aai.pnfList', 'context-list.aai.vnfList', 'context-list.aai.networkList'
    }
  }
}

rule {
    name        'AAI-not-empty'
    category    'VNFC Consistency'
    description 'Check if AAI collected anything'
    errorText   'AAI section is empty'
    severity    'ERROR'
    attributes  'pnfList', 'vnfList', 'networkList'
    validate    '''
        // expect at least one not empty list
        return !pnfList.isEmpty() || !vnfList.isEmpty() || !networkList.isEmpty()
                '''
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
  name        'Attribute-comparison'
  category    'Attribute Mismatch'
  description 'Determine all discrepancies between values for attributes with matching names from each model'
  errorText   'Error found with attribute(s) and values: {0}'
  severity    'ERROR'
  attributes  'lhsObject', 'rhsObject'
  validate    '''
		// This closure extracts the given object's root level attributes and contents of the attribute list.
		// Complex items like lists are excluded.
		// Returns a map containing attribute names as keys, mapping to a list of values for each attribute.
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

		// This closure compares all values for each key from the left map, to values of the same key from the right map.
		// Returns a map of attributes with mismatched or missing values (i.e. attribute name mapped to list of failed values).
		Closure<java.util.Map> compareAttributes = { java.util.Map left, java.util.Map right ->
			java.util.Map violationMap = new java.util.HashMap()
			left.each{ leftKey, leftValueList ->
				def rightValueList = right.get("$leftKey")
				rightValueList.each{ rightValue ->
					if(!leftValueList.any{ it == "$rightValue" }) {
						def existingValues = violationMap.get(leftKey)
						if(existingValues) {
							existingValues.add("$rightValue")
						} else {
							java.util.Set newValues = new HashSet()
							newValues.add("$rightValue")
							violationMap.put("$leftKey", newValues)
						}
					}
				}
			}
			return violationMap
		}

		// This closure merges the given maps into a new map.
		// Returns a map containing all keys and their values from both maps.
		Closure<java.util.Map> mergeMaps = { java.util.Map left, java.util.Map right ->
			if(left.isEmpty() && right.isEmpty()) {
				return [:]
			} else if(left.isEmpty()) {
				return right
			} else if(right.isEmpty()) {
				return left
			}
			java.util.Map merged = new java.util.HashMap()
			merged.putAll(left)
			right.each{ rightKey, rightValues ->
				java.util.Set mergedValues = merged.get(rightKey)
				if(mergedValues == null) {
					merged.put(rightKey, rightValues)
				} else {
					mergedValues.addAll(rightValues)
				}
			}
			return merged
		}

		def slurper = new groovy.json.JsonSlurper()
		java.util.Map lhsAttributes = getAttributes(slurper.parseText(lhsObject.toString()))
		java.util.Map rhsAttributes = getAttributes(slurper.parseText(rhsObject.toString()))

		def leftToRight = compareAttributes(lhsAttributes, rhsAttributes)
		def rightToLeft = compareAttributes(rhsAttributes, lhsAttributes)
		def mergedResults = mergeMaps(leftToRight, rightToLeft)

		boolean success = true
		List<String> details = new ArrayList<>()
		if(!mergedResults.isEmpty()) {
			success = false
			details.add(mergedResults.toString())
		}
		return new Tuple2(success, details)
        '''
}

/*
 * The data-dictionary rule below can be used with this useRule clause:
 *   useRule {
 *     name 'Data-Dictionary validate VF type'
 *     attributes 'context-list.ndcb.vnfList[*].vfModuleList[*].networkList[*].type'
 *   }
 */
rule {
    name        'Data-Dictionary validate VF type'
    category    'INVALID_VALUE'
    description 'Validate all VF type values against data-dictionary'
    errorText   'VF type [{0}] failed data-dictionary validation: {1}'
    severity    'ERROR'
    attributes  'typeList'
    validate    '''
        boolean success = true
        List<String> details = new ArrayList<>()
        typeList.any {
            if(!success) {
                // break out of 'any' loop
                return false
            }
            def result = org.onap.aai.validation.ruledriven.rule.builtin.DataDictionary.validate("instance", "vfModuleNetworkType", "type", "$it")
            if(!result.isEmpty()) {
                success = false
                details.add("$it")
                details.add("$result")
            }
        }
        return new Tuple2(success, details)
        '''
}

rule {
  name        'AAI-SDNC-pnf-name-check'
  category    'PNF Consistency'
  description 'Validate that each PNF name in AAI matches a PNF name in the SDNC model'
  errorText   'AAI PNF names do not match SDNC - {0}'
  severity    'ERROR'
  attributes  'aaiNames', 'sdncNames'
  validate    '''
        def addName = { values, key ->
                values.add("$key")
        }

        List<String> errorReasons = new ArrayList();

        if (aaiNames.size() != sdncNames.size()) {
            errorReasons.add("Number of PNFs don't match; aai has ${aaiNames.size()}, sdnc has ${sdncNames.size()}")
            return new Tuple2(false, errorReasons)
        }

        // collect all the "name" values from AAI and SDNC into two Sets.
        Set aaiNameSet = new java.util.HashSet()
        aaiNames.each {
           aValue -> addName(aaiNameSet, aValue)
        }

        Set sdncNameSet = new java.util.HashSet()
        sdncNames.each {
            aValue -> addName(sdncNameSet, aValue)
        }

        // Validate that the names match by comparing the size of the two Sets.
        if (aaiNameSet.size() != sdncNameSet.size()) {
            errorReasons.add("Number of distinct PNF names don't match; aai: ${aaiNameSet}, sdnc: ${sdncNameSet}")
            return new Tuple2(false, errorReasons)
        }

        Set combinedSet = new HashSet();
        combinedSet.addAll(aaiNameSet);
        combinedSet.addAll(sdncNameSet);
        if (combinedSet.size() != aaiNameSet.size()) {
            errorReasons.add("PNF names don't match; aai names: ${aaiNameSet}, sdnc names: ${sdncNameSet}")
            return new Tuple2(false, errorReasons)
        }

        return true

        '''
}
