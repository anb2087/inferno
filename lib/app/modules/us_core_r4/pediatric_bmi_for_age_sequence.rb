
module Inferno
  module Sequence
    class PediatricBmiForAgeSequence < SequenceBase

      group 'US Core R4 Profile Conformance'

      title 'US Core R4 PediatricBmiForAge Tests'

      description 'Verify that Observation resources on the FHIR server follow the Argonaut Data Query Implementation Guide'

      test_id_prefix 'Observation' # change me

      requires :token, :patient_id
      conformance_supports :Observation

      
        def validate_resource_item (resource, property, value)
          case property
          
          when 'patient'
            assert (resource&.subject && resource.subject.reference.include?(value)), "patient on resource does not match patient requested"
        
          when 'status'
            assert resource&.status != nil && resource&.status == value, "status on resource did not match status requested"
        
          when 'category'
            codings = resource&.category.first&.coding
            assert !codings.nil?, "category on resource did not match category requested"
            assert codings.any? {|coding| !coding.try(:code).nil? && coding.try(:code) == value}, "category on resource did not match category requested"
        
          when 'code'
            codings = resource&.code&.coding
            assert !codings.nil?, "code on resource did not match code requested"
            assert codings.any? {|coding| !coding.try(:code).nil? && coding.try(:code) == value}, "code on resource did not match code requested"
        
          when 'date'
        
          end
        end
    

      details %(
        
        The #{title} Sequence tests `#{title.gsub(/\s+/,"")}` resources associated with the provided patient.  The resources
        returned will be checked for consistency against the [PediatricBmiForAge Argonaut Profile](https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-pediatric-bmi-for-age)

      )

      @resources_found = false
      
      test 'Server rejects Observation search without authorization' do
        metadata {
          id '01'
          link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
          desc %(
          )
          versions :r4
        }
        
        @client.set_no_auth
        skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?

        reply = get_resource_by_params(versioned_resource_class('Observation'), {patient: @instance.patient_id})
        @client.set_bearer_token(@instance.token)
        assert_response_unauthorized reply
  
      end
      
      test 'Server returns expected results from Observation search by patient+code' do
        metadata {
          id '02'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        
        search_params = {patient: @instance.patient_id, code: "59576-9"}
      
        reply = get_resource_by_params(versioned_resource_class('Observation'), search_params)
        assert_response_ok(reply)
        assert_bundle_response(reply)

        resource_count = reply.try(:resource).try(:entry).try(:length) || 0
        if resource_count > 0
          @resources_found = true
        end

        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        @observation = reply.try(:resource).try(:entry).try(:first).try(:resource)
        validate_search_reply(versioned_resource_class('Observation'), reply, search_params)
        save_resource_ids_in_bundle(versioned_resource_class('Observation'), reply)
    
      end
      
      test 'Server returns expected results from Observation search by patient+category' do
        metadata {
          id '03'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@observation.nil?, 'Expected valid Observation resource to be present'
        
        patient_val = @instance.patient_id
        category_val = @observation&.category.first&.coding&.first&.code
        search_params = {'patient': patient_val, 'category': category_val}
  
        reply = get_resource_by_params(versioned_resource_class('Observation'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Observation search by patient+category+date' do
        metadata {
          id '04'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@observation.nil?, 'Expected valid Observation resource to be present'
        
        patient_val = @instance.patient_id
        category_val = @observation&.category.first&.coding&.first&.code
        date_val = @observation&.effectiveDateTime
        search_params = {'patient': patient_val, 'category': category_val, 'date': date_val}
  
        reply = get_resource_by_params(versioned_resource_class('Observation'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Observation search by patient+code+date' do
        metadata {
          id '05'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@observation.nil?, 'Expected valid Observation resource to be present'
        
        patient_val = @instance.patient_id
        code_val = @observation&.code&.coding&.first&.code
        date_val = @observation&.effectiveDateTime
        search_params = {'patient': patient_val, 'code': code_val, 'date': date_val}
  
        reply = get_resource_by_params(versioned_resource_class('Observation'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Observation search by patient+category+status' do
        metadata {
          id '06'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@observation.nil?, 'Expected valid Observation resource to be present'
        
        patient_val = @instance.patient_id
        category_val = @observation&.category.first&.coding&.first&.code
        status_val = @observation&.status
        search_params = {'patient': patient_val, 'category': category_val, 'status': status_val}
  
        reply = get_resource_by_params(versioned_resource_class('Observation'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Observation read resource supported' do
        metadata {
          id '07'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Observation, [:read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_read_reply(@observation, versioned_resource_class('Observation'))
  
      end
      
      test 'Observation vread resource supported' do
        metadata {
          id '08'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Observation, [:vread])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_vread_reply(@observation, versioned_resource_class('Observation'))
  
      end
      
      test 'Observation history resource supported' do
        metadata {
          id '09'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Observation, [:history])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_history_reply(@observation, versioned_resource_class('Observation'))
  
      end
      
      test 'Demonstrates that the server can supply Observation.status' do
        metadata {
          id '10'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.status" then
          assert can_resolve_path(@observation, 'status'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.status,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.category' do
        metadata {
          id '11'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.category" then
          assert can_resolve_path(@observation, 'category'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.category,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.category' do
        metadata {
          id '12'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.category" then
          assert can_resolve_path(@observation, 'category'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.category,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.category.coding' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.category.coding" then
          assert can_resolve_path(@observation, 'category.coding'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.category.coding,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.category.coding.system' do
        metadata {
          id '14'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.category.coding.system" then
          assert can_resolve_path(@observation, 'category.coding.system'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.category.coding.system,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.category.coding.code' do
        metadata {
          id '15'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.category.coding.code" then
          assert can_resolve_path(@observation, 'category.coding.code'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.category.coding.code,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.subject' do
        metadata {
          id '16'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.subject" then
          assert can_resolve_path(@observation, 'subject'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.subject,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.effective[x]' do
        metadata {
          id '17'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.effective[x]" then
          assert can_resolve_path(@observation, 'effectivedateTime') || can_resolve_path(@observation, 'effectivePeriod'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.effective[x],"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.value[x].value' do
        metadata {
          id '18'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.value[x].value" then
          assert can_resolve_path(@observation, 'valueQuantity.value'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.value[x].value,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.value[x].unit' do
        metadata {
          id '19'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.value[x].unit" then
          assert can_resolve_path(@observation, 'valueQuantity.unit'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.value[x].unit,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.value[x].system' do
        metadata {
          id '20'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.value[x].system" then
          assert can_resolve_path(@observation, 'valueQuantity.system'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.value[x].system,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.value[x].code' do
        metadata {
          id '21'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.value[x].code" then
          assert can_resolve_path(@observation, 'valueQuantity.code'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.value[x].code,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.dataAbsentReason' do
        metadata {
          id '22'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.dataAbsentReason" then
          assert can_resolve_path(@observation, 'dataAbsentReason'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.dataAbsentReason,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.component' do
        metadata {
          id '23'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.component" then
          assert can_resolve_path(@observation, 'component'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.component,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.component.code' do
        metadata {
          id '24'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.component.code" then
          assert can_resolve_path(@observation, 'component.code'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.component.code,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.component.value[x]' do
        metadata {
          id '25'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.component.value[x]" then
          assert can_resolve_path(@observation, 'component.valueQuantity') || can_resolve_path(@observation, 'component.valueCodeableConcept') || can_resolve_path(@observation, 'component.valuestring') || can_resolve_path(@observation, 'component.valueboolean') || can_resolve_path(@observation, 'component.valueinteger') || can_resolve_path(@observation, 'component.valueRange') || can_resolve_path(@observation, 'component.valueRatio') || can_resolve_path(@observation, 'component.valueSampledData') || can_resolve_path(@observation, 'component.valuetime') || can_resolve_path(@observation, 'component.valuedateTime') || can_resolve_path(@observation, 'component.valuePeriod'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.component.value[x],"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Observation.component.dataAbsentReason' do
        metadata {
          id '26'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Observation.component.dataAbsentReason" then
          assert can_resolve_path(@observation, 'component.dataAbsentReason'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Observation.component.dataAbsentReason,"
          @instance.save!
        end
  
      end
      
      test 'Observation resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '27'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-pediatric-bmi-for-age.json'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        test_resources_against_profile('Observation')
  
      end
      
      test 'All references can be resolved' do
        metadata {
          id '28'
          link 'https://www.hl7.org/fhir/DSTU2/references.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Observation, [:search, :read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_reference_resolutions(@observation)
  
      end
      
    end
  end
end