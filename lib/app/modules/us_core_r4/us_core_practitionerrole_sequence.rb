
module Inferno
  module Sequence
    class UsCoreR4PractitionerroleSequence < SequenceBase

      group 'US Core R4 Profile Conformance'

      title 'US Core R4 Practitionerrole Tests'

      description 'Verify that PractitionerRole resources on the FHIR server follow the Argonaut Data Query Implementation Guide'

      test_id_prefix 'PractitionerRole' # change me

      requires :token, :patient_id
      conformance_supports :PractitionerRole

      
        def validate_resource_item (resource, property, value)
          case property
          
          when 'specialty'
            codings = resource&.specialty&.coding
            assert !codings.nil?, "specialty on resource did not match specialty requested"
            assert codings.any? {|coding| !coding.try(:code).nil? && coding.try(:code) == value}, "specialty on resource did not match specialty requested"
        
          when 'practitioner'
            assert (resource&.practitioner && resource.practitioner.reference.include?(value)), "practitioner on resource does not match practitioner requested"
        
          end
        end
    

      details %(
        
        The #{title} Sequence tests `#{title.gsub(/\s+/,"")}` resources associated with the provided patient.  The resources
        returned will be checked for consistency against the [Practitionerrole Argonaut Profile](https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-practitionerrole)

      )

      @resources_found = false
      
      test 'Server rejects PractitionerRole search without authorization' do
        metadata {
          id '01'
          link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
          desc %(
          )
          versions :r4
        }
        
        @client.set_no_auth
        skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?

        reply = get_resource_by_params(versioned_resource_class('PractitionerRole'), {patient: @instance.patient_id})
        @client.set_bearer_token(@instance.token)
        assert_response_unauthorized reply
  
      end
      
      test 'Server returns expected results from PractitionerRole search by specialty' do
        metadata {
          id '02'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        
        specialty_val = @practitionerrole&.specialty&.coding&.first&.code
        search_params = {'specialty': specialty_val}
  
        reply = get_resource_by_params(versioned_resource_class('PractitionerRole'), search_params)
        assert_response_ok(reply)
        assert_bundle_response(reply)

        resource_count = reply.try(:resource).try(:entry).try(:length) || 0
        if resource_count > 0
          @resources_found = true
        end

        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        @practitionerrole = reply.try(:resource).try(:entry).try(:first).try(:resource)
        validate_search_reply(versioned_resource_class('PractitionerRole'), reply, search_params)
        save_resource_ids_in_bundle(versioned_resource_class('PractitionerRole'), reply)
    
      end
      
      test 'Server returns expected results from PractitionerRole search by practitioner' do
        metadata {
          id '03'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@practitionerrole.nil?, 'Expected valid PractitionerRole resource to be present'
        
        practitioner_val = @practitionerrole&.practitioner&.reference.first
        search_params = {'practitioner': practitioner_val}
  
        reply = get_resource_by_params(versioned_resource_class('PractitionerRole'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'PractitionerRole read resource supported' do
        metadata {
          id '04'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:PractitionerRole, [:read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_read_reply(@practitionerrole, versioned_resource_class('PractitionerRole'))
  
      end
      
      test 'PractitionerRole vread resource supported' do
        metadata {
          id '05'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:PractitionerRole, [:vread])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_vread_reply(@practitionerrole, versioned_resource_class('PractitionerRole'))
  
      end
      
      test 'PractitionerRole history resource supported' do
        metadata {
          id '06'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:PractitionerRole, [:history])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_history_reply(@practitionerrole, versioned_resource_class('PractitionerRole'))
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.practitioner' do
        metadata {
          id '07'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.practitioner" then
          assert can_resolve_path(@practitionerrole, 'practitioner'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.practitioner,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.organization' do
        metadata {
          id '08'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.organization" then
          assert can_resolve_path(@practitionerrole, 'organization'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.organization,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.code' do
        metadata {
          id '09'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.code" then
          assert can_resolve_path(@practitionerrole, 'code'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.code,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.specialty' do
        metadata {
          id '10'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.specialty" then
          assert can_resolve_path(@practitionerrole, 'specialty'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.specialty,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.location' do
        metadata {
          id '11'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.location" then
          assert can_resolve_path(@practitionerrole, 'location'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.location,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.telecom' do
        metadata {
          id '12'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.telecom" then
          assert can_resolve_path(@practitionerrole, 'telecom'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.telecom,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.telecom.system' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.telecom.system" then
          assert can_resolve_path(@practitionerrole, 'telecom.system'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.telecom.system,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.telecom.value' do
        metadata {
          id '14'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.telecom.value" then
          assert can_resolve_path(@practitionerrole, 'telecom.value'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.telecom.value,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply PractitionerRole.endpoint' do
        metadata {
          id '15'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "PractitionerRole.endpoint" then
          assert can_resolve_path(@practitionerrole, 'endpoint'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "PractitionerRole.endpoint,"
          @instance.save!
        end
  
      end
      
      test 'PractitionerRole resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '16'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-practitionerrole.json'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        test_resources_against_profile('PractitionerRole')
  
      end
      
      test 'All references can be resolved' do
        metadata {
          id '17'
          link 'https://www.hl7.org/fhir/DSTU2/references.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:PractitionerRole, [:search, :read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_reference_resolutions(@practitionerrole)
  
      end
      
    end
  end
end