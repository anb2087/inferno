
module Inferno
  module Sequence
    class UsCoreR4EncounterSequence < SequenceBase

      group 'US Core R4 Profile Conformance'

      title 'US Core R4 Encounter Tests'

      description 'Verify that Encounter resources on the FHIR server follow the Argonaut Data Query Implementation Guide'

      test_id_prefix 'Encounter' # change me

      requires :token, :patient_id
      conformance_supports :Encounter

      
        def validate_resource_item (resource, property, value)
          case property
          
          when 'patient'
            assert (resource&.subject && resource.subject.reference.include?(value)), "patient on resource does not match patient requested"
        
          when '_id'
            assert resource&.id != nil && resource&.id == value, "_id on resource did not match _id requested"
        
          when 'class'
            assert !resource&.class&.code.nil? && resource&.class&.code == value, "class on resource did not match class requested"
        
          when 'date'
        
          when 'status'
            assert resource&.status != nil && resource&.status == value, "status on resource did not match status requested"
        
          when 'type'
            codings = resource&.type.first&.coding
            assert !codings.nil?, "type on resource did not match type requested"
            assert codings.any? {|coding| !coding.try(:code).nil? && coding.try(:code) == value}, "type on resource did not match type requested"
        
          end
        end
    

      details %(
        
        The #{title} Sequence tests `#{title.gsub(/\s+/,"")}` resources associated with the provided patient.  The resources
        returned will be checked for consistency against the [Encounter Argonaut Profile](https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-encounter)

      )

      @resources_found = false
      
      test 'Server rejects Encounter search without authorization' do
        metadata {
          id '01'
          link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
          desc %(
          )
          versions :r4
        }
        
        @client.set_no_auth
        skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?

        reply = get_resource_by_params(versioned_resource_class('Encounter'), {patient: @instance.patient_id})
        @client.set_bearer_token(@instance.token)
        assert_response_unauthorized reply
  
      end
      
      test 'Server returns expected results from Encounter search by patient' do
        metadata {
          id '02'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        
        patient_val = @instance.patient_id
        search_params = {'patient': patient_val}
  
        reply = get_resource_by_params(versioned_resource_class('Encounter'), search_params)
        assert_response_ok(reply)
        assert_bundle_response(reply)

        resource_count = reply.try(:resource).try(:entry).try(:length) || 0
        if resource_count > 0
          @resources_found = true
        end

        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        @encounter = reply.try(:resource).try(:entry).try(:first).try(:resource)
        validate_search_reply(versioned_resource_class('Encounter'), reply, search_params)
        save_resource_ids_in_bundle(versioned_resource_class('Encounter'), reply)
    
      end
      
      test 'Server returns expected results from Encounter search by _id' do
        metadata {
          id '03'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@encounter.nil?, 'Expected valid Encounter resource to be present'
        
        _id_val = @encounter&.id
        search_params = {'_id': _id_val}
  
        reply = get_resource_by_params(versioned_resource_class('Encounter'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Encounter search by date+patient' do
        metadata {
          id '04'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@encounter.nil?, 'Expected valid Encounter resource to be present'
        
        date_val = @encounter&.period&.start
        patient_val = @instance.patient_id
        search_params = {'date': date_val, 'patient': patient_val}
  
        reply = get_resource_by_params(versioned_resource_class('Encounter'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Encounter search by identifier' do
        metadata {
          id '05'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@encounter.nil?, 'Expected valid Encounter resource to be present'
        
        identifier_val = @encounter&.identifier.first&.value
        search_params = {'identifier': identifier_val}
  
        reply = get_resource_by_params(versioned_resource_class('Encounter'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Encounter search by patient+status' do
        metadata {
          id '06'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@encounter.nil?, 'Expected valid Encounter resource to be present'
        
        patient_val = @instance.patient_id
        status_val = @encounter&.status
        search_params = {'patient': patient_val, 'status': status_val}
  
        reply = get_resource_by_params(versioned_resource_class('Encounter'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Encounter search by class+patient' do
        metadata {
          id '07'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@encounter.nil?, 'Expected valid Encounter resource to be present'
        
        class_val = @encounter&.class&.code
        patient_val = @instance.patient_id
        search_params = {'class': class_val, 'patient': patient_val}
  
        reply = get_resource_by_params(versioned_resource_class('Encounter'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Encounter search by patient+type' do
        metadata {
          id '08'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@encounter.nil?, 'Expected valid Encounter resource to be present'
        
        patient_val = @instance.patient_id
        type_val = @encounter&.type.first&.coding&.first&.code
        search_params = {'patient': patient_val, 'type': type_val}
  
        reply = get_resource_by_params(versioned_resource_class('Encounter'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Encounter read resource supported' do
        metadata {
          id '09'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Encounter, [:read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_read_reply(@encounter, versioned_resource_class('Encounter'))
  
      end
      
      test 'Encounter vread resource supported' do
        metadata {
          id '10'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Encounter, [:vread])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_vread_reply(@encounter, versioned_resource_class('Encounter'))
  
      end
      
      test 'Encounter history resource supported' do
        metadata {
          id '11'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Encounter, [:history])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_history_reply(@encounter, versioned_resource_class('Encounter'))
  
      end
      
      test 'Demonstrates that the server can supply must supported elements' do
        metadata {
          id '12'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
            skip 'Could not find Encounter.identifier in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.identifier") || can_resolve_path(@encounter, 'identifier')
            @instance.must_support_confirmed += 'Encounter.identifier'
        
            skip 'Could not find Encounter.identifier.system in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.identifier.system") || can_resolve_path(@encounter, 'identifier.system')
            @instance.must_support_confirmed += 'Encounter.identifier.system'
        
            skip 'Could not find Encounter.identifier.value in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.identifier.value") || can_resolve_path(@encounter, 'identifier.value')
            @instance.must_support_confirmed += 'Encounter.identifier.value'
        
            skip 'Could not find Encounter.status in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.status") || can_resolve_path(@encounter, 'status')
            @instance.must_support_confirmed += 'Encounter.status'
        
            skip 'Could not find Encounter.class in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.class") || can_resolve_path(@encounter, 'class')
            @instance.must_support_confirmed += 'Encounter.class'
        
            skip 'Could not find Encounter.type in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.type") || can_resolve_path(@encounter, 'type')
            @instance.must_support_confirmed += 'Encounter.type'
        
            skip 'Could not find Encounter.subject in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.subject") || can_resolve_path(@encounter, 'subject')
            @instance.must_support_confirmed += 'Encounter.subject'
        
            skip 'Could not find Encounter.participant in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.participant") || can_resolve_path(@encounter, 'participant')
            @instance.must_support_confirmed += 'Encounter.participant'
        
            skip 'Could not find Encounter.participant.type in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.participant.type") || can_resolve_path(@encounter, 'participant.type')
            @instance.must_support_confirmed += 'Encounter.participant.type'
        
            skip 'Could not find Encounter.participant.period in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.participant.period") || can_resolve_path(@encounter, 'participant.period')
            @instance.must_support_confirmed += 'Encounter.participant.period'
        
            skip 'Could not find Encounter.participant.individual in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.participant.individual") || can_resolve_path(@encounter, 'participant.individual')
            @instance.must_support_confirmed += 'Encounter.participant.individual'
        
            skip 'Could not find Encounter.period in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.period") || can_resolve_path(@encounter, 'period')
            @instance.must_support_confirmed += 'Encounter.period'
        
            skip 'Could not find Encounter.reasonCode in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.reasonCode") || can_resolve_path(@encounter, 'reasonCode')
            @instance.must_support_confirmed += 'Encounter.reasonCode'
        
            skip 'Could not find Encounter.hospitalization in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.hospitalization") || can_resolve_path(@encounter, 'hospitalization')
            @instance.must_support_confirmed += 'Encounter.hospitalization'
        
            skip 'Could not find Encounter.hospitalization.dischargeDisposition in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.hospitalization.dischargeDisposition") || can_resolve_path(@encounter, 'hospitalization.dischargeDisposition')
            @instance.must_support_confirmed += 'Encounter.hospitalization.dischargeDisposition'
        
            skip 'Could not find Encounter.location in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.location") || can_resolve_path(@encounter, 'location')
            @instance.must_support_confirmed += 'Encounter.location'
        
            skip 'Could not find Encounter.location.location in the provided resource' unless (@instance.must_support_confirmed.include? "Encounter.location.location") || can_resolve_path(@encounter, 'location.location')
            @instance.must_support_confirmed += 'Encounter.location.location'
        
        @instance.save!
  
      end
      
      test 'Encounter resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-encounter.json'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        test_resources_against_profile('Encounter')
  
      end
      
      test 'All references can be resolved' do
        metadata {
          id '14'
          link 'https://www.hl7.org/fhir/DSTU2/references.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Encounter, [:search, :read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_reference_resolutions(@encounter)
  
      end
      
    end
  end
end