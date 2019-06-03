
module Inferno
  module Sequence
    class UsCoreR4MedicationstatementSequence < SequenceBase

      group 'US Core R4 Profile Conformance'

      title 'US Core R4 Medicationstatement Tests'

      description 'Verify that MedicationStatement resources on the FHIR server follow the Argonaut Data Query Implementation Guide'

      test_id_prefix 'MedicationStatement' # change me

      requires :token, :patient_id
      conformance_supports :MedicationStatement

      
        def validate_resource_item (resource, property, value)
          case property
          
          when 'patient'
            assert (resource&.subject && resource.subject.reference.include?(value)), "patient on resource does not match patient requested"
        
          when 'status'
            assert resource&.status != nil && resource&.status == value, "status on resource did not match status requested"
        
          when 'effective'
        
          end
        end
    

      details %(
        
        The #{title} Sequence tests `#{title.gsub(/\s+/,"")}` resources associated with the provided patient.  The resources
        returned will be checked for consistency against the [Medicationstatement Argonaut Profile](https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-medicationstatement)

      )

      @resources_found = false
      
      test 'Server rejects MedicationStatement search without authorization' do
        metadata {
          id '01'
          link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
          desc %(
          )
          versions :r4
        }
        
        @client.set_no_auth
        skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?

        reply = get_resource_by_params(versioned_resource_class('MedicationStatement'), {patient: @instance.patient_id})
        @client.set_bearer_token(@instance.token)
        assert_response_unauthorized reply
  
      end
      
      test 'Server returns expected results from MedicationStatement search by patient' do
        metadata {
          id '02'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        
        patient_val = @instance.patient_id
        search_params = {'patient': patient_val}
  
        reply = get_resource_by_params(versioned_resource_class('MedicationStatement'), search_params)
        assert_response_ok(reply)
        assert_bundle_response(reply)

        resource_count = reply.try(:resource).try(:entry).try(:length) || 0
        if resource_count > 0
          @resources_found = true
        end

        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        @medicationstatement = reply.try(:resource).try(:entry).try(:first).try(:resource)
        validate_search_reply(versioned_resource_class('MedicationStatement'), reply, search_params)
        save_resource_ids_in_bundle(versioned_resource_class('MedicationStatement'), reply)
    
      end
      
      test 'Server returns expected results from MedicationStatement search by patient+effective' do
        metadata {
          id '03'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@medicationstatement.nil?, 'Expected valid MedicationStatement resource to be present'
        
        patient_val = @instance.patient_id
        effective_val = @medicationstatement&.effectiveDateTime
        search_params = {'patient': patient_val, 'effective': effective_val}
  
        reply = get_resource_by_params(versioned_resource_class('MedicationStatement'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from MedicationStatement search by patient+status' do
        metadata {
          id '04'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@medicationstatement.nil?, 'Expected valid MedicationStatement resource to be present'
        
        patient_val = @instance.patient_id
        status_val = @medicationstatement&.status
        search_params = {'patient': patient_val, 'status': status_val}
  
        reply = get_resource_by_params(versioned_resource_class('MedicationStatement'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'MedicationStatement read resource supported' do
        metadata {
          id '05'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:MedicationStatement, [:read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_read_reply(@medicationstatement, versioned_resource_class('MedicationStatement'))
  
      end
      
      test 'MedicationStatement vread resource supported' do
        metadata {
          id '06'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:MedicationStatement, [:vread])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_vread_reply(@medicationstatement, versioned_resource_class('MedicationStatement'))
  
      end
      
      test 'MedicationStatement history resource supported' do
        metadata {
          id '07'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:MedicationStatement, [:history])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_history_reply(@medicationstatement, versioned_resource_class('MedicationStatement'))
  
      end
      
      test 'Demonstrates that the server can supply MedicationStatement.status' do
        metadata {
          id '08'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "MedicationStatement.status" then
          assert can_resolve_path(@medicationstatement, 'status'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "MedicationStatement.status,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply MedicationStatement.medication[x]' do
        metadata {
          id '09'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "MedicationStatement.medication[x]" then
          assert can_resolve_path(@medicationstatement, 'medicationCodeableConcept') || can_resolve_path(@medicationstatement, 'medicationReference'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "MedicationStatement.medication[x],"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply MedicationStatement.subject' do
        metadata {
          id '10'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "MedicationStatement.subject" then
          assert can_resolve_path(@medicationstatement, 'subject'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "MedicationStatement.subject,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply MedicationStatement.effective[x]' do
        metadata {
          id '11'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "MedicationStatement.effective[x]" then
          assert can_resolve_path(@medicationstatement, 'effectivedateTime') || can_resolve_path(@medicationstatement, 'effectivePeriod'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "MedicationStatement.effective[x],"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply MedicationStatement.dateAsserted' do
        metadata {
          id '12'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "MedicationStatement.dateAsserted" then
          assert can_resolve_path(@medicationstatement, 'dateAsserted'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "MedicationStatement.dateAsserted,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply MedicationStatement.derivedFrom' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "MedicationStatement.derivedFrom" then
          assert can_resolve_path(@medicationstatement, 'derivedFrom'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "MedicationStatement.derivedFrom,"
          @instance.save!
        end
  
      end
      
      test 'MedicationStatement resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '14'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-medicationstatement.json'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        test_resources_against_profile('MedicationStatement')
  
      end
      
      test 'All references can be resolved' do
        metadata {
          id '15'
          link 'https://www.hl7.org/fhir/DSTU2/references.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:MedicationStatement, [:search, :read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_reference_resolutions(@medicationstatement)
  
      end
      
    end
  end
end