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
	
		// Context level
		useRule {
			name 'NDCB-AAI-attribute-comparison'
			attributes 'context-list.ndcb', 'context-list.aai'
		}
		
		// Service entity
		useRule {
			name 'NDCB-AAI-attribute-comparison'
			attributes 'context-list.ndcb.service', 'context-list.aai.service'
		}
		
		// VF list
		useRule {
			name 'NDCB-AAI-attribute-comparison'
			attributes 'context-list.ndcb.vfList[*]', 'context-list.aai.vfList[*]'
		}
		
		// VF-Module list
		useRule {
			name 'NDCB-AAI-attribute-comparison'
			attributes 'context-list.ndcb.vfList[*].vfModuleList[*]', 'context-list.aai.vfList[*].vfModuleList[*]'
		}
		
		// VNFC list
		useRule {
			name 'NDCB-AAI-attribute-comparison'
			attributes 'context-list.ndcb.vfList[*].vnfcList[*]', 'context-list.aai.vfList[*].vnfcList[*]'
		}
		
		// VM list
		useRule {
			name 'NDCB-AAI-attribute-comparison'
			attributes 'context-list.ndcb.vfList[*].vfModuleList[*].vmList[*]', 'context-list.aai.vfList[*].vfModuleList[*].vmList[*]'
		}
		
		// Network list
		useRule {
			name 'NDCB-AAI-attribute-comparison'
			attributes 'context-list.ndcb.vfList[*].vfModuleList[*].networkList[*]', 'context-list.aai.vfList[*].vfModuleList[*].networkList[*]'
		}
		
	}
}

rule {
	name        'Verify AAI nf-naming-code'
	category    'INVALID_VALUE'
	description 'Validate that nf-naming-code exists and is populated in AAI VNF instance'
	errorText   'The nf-naming-code is not populated in AAI VNF instance'
	severity    'CRITICAL'
	attributes  'vfList'
	validate    '''
				def parsed = new groovy.json.JsonSlurper().parseText(vfList.toString())
				for (vf in parsed) {
					String nfNamingCode = vf."nf-naming-code"
					if (nfNamingCode == null || nfNamingCode.equals("")) {
						return false
					}
				}
				return true
                '''
}

rule {
	name        'port-mirroring-AAI-has-valid-vnfc'
	category    'INVALID_VALUE'
	description 'Validate that each VNFC instance in AAI conforms to a VNFC type defined in SDC model'
	errorText   'AAI VNFC instance includes non-specified type in design SDC model'
	severity    'ERROR'
	attributes  'sdcVfList', 'aaiVfList'
	validate    '''
				def slurper = new groovy.json.JsonSlurper()
				def parsedSdc = slurper.parseText(sdcVfList.toString())
				def parsedAai = slurper.parseText(aaiVfList.toString())

				// gather all SDC nfc-naming-codes
				List<String> sdcNfcNamingCodeList = new ArrayList<>()
				parsedSdc.each {
					for(sdcVnfc in it.vnfc) {
						String sdcNfcNamingCode = sdcVnfc."nfc-naming-code"
						if(sdcNfcNamingCode != null) {
							sdcNfcNamingCodeList.add(sdcNfcNamingCode)
						}
					}
				}

				// check that all SDC nfc-naming-codes exist in AAI
				parsedAai.each {
					for(aaiVnfc in it.vnfc) {
						String aaiNfcNamingCode = aaiVnfc."nfc-naming-code"
						if(aaiNfcNamingCode != null) {
							if(!sdcNfcNamingCodeList.contains(aaiNfcNamingCode)) {
								return false
							}
						}
					}
				}
				return true
                '''
}

rule {
	name        'port-mirroring-SDC-vnfc-types-missing'
	category    'INVALID_VALUE'
	description 'Validate that each VNFC type specified in SDC model exists in AAI'
	errorText   'Design has specified types but not all of them exist in AAI'
	severity    'WARNING'
	attributes  'sdcVfList', 'aaiVfList'
	validate    '''
				def getNfcNamingCodeSet = { parsedEntity ->
					Set<String> namingCodeSet = new HashSet<>()
					parsedEntity.each {
						for(vnfcItem in it."vnfc") {
							String namingCode = vnfcItem."nfc-naming-code"
							if(namingCode != null) {
								namingCodeSet.add(namingCode)
							}
						}
					}
					return namingCodeSet
				}

				// gather all unique nfc-naming-codes from AAI and SDC
				def slurper = new groovy.json.JsonSlurper()
				def aaiNfcNamingCodeSet = getNfcNamingCodeSet(slurper.parseText(aaiVfList.toString())) as java.util.HashSet
				def sdcNfcNamingCodeSet = getNfcNamingCodeSet(slurper.parseText(sdcVfList.toString())) as java.util.HashSet
				
				// check that all nfc-naming-codes in SDC exist in AAI
				return aaiNfcNamingCodeSet.containsAll(sdcNfcNamingCodeSet)
                '''
}

rule {
	name        'port-mirroring-AAI-vnfc-type-exists-in-SDC-SUCCESS'
	category    'SUCCESS'
	description 'Verify that every vnfc in sdc has been created in AAI'
	errorText   'Every vnfc type specified in sdc has been created in AAI'
	severity    'INFO'
	attributes  'sdcVfList', 'aaiVfList'
	validate    '''
				def getNfcNamingCodeSet = { parsedEntity ->
					Set<String> namingCodeSet = new HashSet<>()
					parsedEntity.each {
						for(vnfcItem in it."vnfc") {
							String namingCode = vnfcItem."nfc-naming-code"
							if(namingCode != null) {
								namingCodeSet.add(namingCode)
							}
						}
					}
					return namingCodeSet
				}

				// gather all unique nfc-naming-codes from AAI and SDC
				def slurper = new groovy.json.JsonSlurper()
				def aaiNfcNamingCodeSet = getNfcNamingCodeSet(slurper.parseText(aaiVfList.toString())) as java.util.HashSet
				def sdcNfcNamingCodeSet = getNfcNamingCodeSet(slurper.parseText(sdcVfList.toString())) as java.util.HashSet

				// check that all nfc-naming-codes in SDC exist in AAI
				// return false if all SDC naming codes exist in AAI to trigger an INFO violation
				return !aaiNfcNamingCodeSet.containsAll(sdcNfcNamingCodeSet)
				'''
}

rule {
	name        'NDCB-AAI-attribute-comparison'
	category    'INVALID_VALUE'
	description 'Verify that every attribute in Network-Discovery is the same as in AAI'
	errorText   'Some attributes in Network-Discovery are not equal to attributes in AAI'
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
				
				ndcb.each{ ndcbKey, ndcbValueList ->
					def aaiValueList = aai.get("$ndcbKey")
					aaiValueList.each{ aaiValue ->
						if(!ndcbValueList.any{ it == "$aaiValue" }) {
							return false
						}
					}
				}
				return true
				'''
}