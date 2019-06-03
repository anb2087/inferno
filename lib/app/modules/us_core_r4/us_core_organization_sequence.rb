
module Inferno
  module Sequence
    class UsCoreR4OrganizationSequence < SequenceBase

      group 'US Core R4 Profile Conformance'

      title 'US Core R4 Organization Tests'

      description 'Verify that Organization resources on the FHIR server follow the Argonaut Data Query Implementation Guide'

      test_id_prefix 'Organization' # change me

      requires :token, :patient_id
      conformance_supports :Organization

      
        def validate_resource_item (resource, property, value)
          case property
          
          when 'name'
            assert resource&.name != nil && resource&.name == value, "name on resource did not match name requested"
        
          when 'address'
        
          end
        end
    

      details %(
        
        The #{title} Sequence tests `#{title.gsub(/\s+/,"")}` resources associated with the provided patient.  The resources
        returned will be checked for consistency against the [Organization Argonaut Profile](https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-organization)

      )

      @resources_found = false
      
      test 'Server rejects Organization search without authorization' do
        metadata {
          id '01'
          link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
          desc %(
          )
          versions :r4
        }
        
        @client.set_no_auth
        skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?

        reply = get_resource_by_params(versioned_resource_class('Organization'), {patient: @instance.patient_id})
        @client.set_bearer_token(@instance.token)
        assert_response_unauthorized reply
  
      end
      
      test 'Server returns expected results from Organization search by name' do
        metadata {
          id '02'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        
        search_params = {patient: @instance.patient_id, name: "Boston"}
      
        reply = get_resource_by_params(versioned_resource_class('Organization'), search_params)
        assert_response_ok(reply)
        assert_bundle_response(reply)

        resource_count = reply.try(:resource).try(:entry).try(:length) || 0
        if resource_count > 0
          @resources_found = true
        end

        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        @organization = reply.try(:resource).try(:entry).try(:first).try(:resource)
        validate_search_reply(versioned_resource_class('Organization'), reply, search_params)
        save_resource_ids_in_bundle(versioned_resource_class('Organization'), reply)
    
      end
      
      test 'Server returns expected results from Organization search by address' do
        metadata {
          id '03'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@organization.nil?, 'Expected valid Organization resource to be present'
        
        address_val = @organization&.address.first
        search_params = {'address': address_val}
  
        reply = get_resource_by_params(versioned_resource_class('Organization'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Organization read resource supported' do
        metadata {
          id '04'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Organization, [:read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_read_reply(@organization, versioned_resource_class('Organization'))
  
      end
      
      test 'Organization vread resource supported' do
        metadata {
          id '05'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Organization, [:vread])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_vread_reply(@organization, versioned_resource_class('Organization'))
  
      end
      
      test 'Organization history resource supported' do
        metadata {
          id '06'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Organization, [:history])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_history_reply(@organization, versioned_resource_class('Organization'))
  
      end
      
      test 'Demonstrates that the server can supply Organization.identifier' do
        metadata {
          id '07'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.identifier" then
          assert can_resolve_path(@organization, 'identifier'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.identifier,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.identifier.system' do
        metadata {
          id '08'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.identifier.system" then
          assert can_resolve_path(@organization, 'identifier.system'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.identifier.system,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.active' do
        metadata {
          id '09'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.active" then
          assert can_resolve_path(@organization, 'active'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.active,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.name' do
        metadata {
          id '10'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.name" then
          assert can_resolve_path(@organization, 'name'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.name,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.telecom' do
        metadata {
          id '11'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.telecom" then
          assert can_resolve_path(@organization, 'telecom'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.telecom,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.address' do
        metadata {
          id '12'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.address" then
          assert can_resolve_path(@organization, 'address'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.address,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.address.line' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.address.line" then
          assert can_resolve_path(@organization, 'address.line'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.address.line,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.address.city' do
        metadata {
          id '14'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.address.city" then
          assert can_resolve_path(@organization, 'address.city'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.address.city,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.address.state' do
        metadata {
          id '15'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.address.state" then
          assert can_resolve_path(@organization, 'address.state'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.address.state,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.address.postalCode' do
        metadata {
          id '16'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.address.postalCode" then
          assert can_resolve_path(@organization, 'address.postalCode'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.address.postalCode,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.address.country' do
        metadata {
          id '17'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.address.country" then
          assert can_resolve_path(@organization, 'address.country'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.address.country,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply Organization.endpoint' do
        metadata {
          id '18'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "Organization.endpoint" then
          assert can_resolve_path(@organization, 'endpoint'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "Organization.endpoint,"
          @instance.save!
        end
  
      end
      
      test 'Organization resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '19'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-organization.json'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        test_resources_against_profile('Organization')
  
      end
      
      test 'All references can be resolved' do
        metadata {
          id '20'
          link 'https://www.hl7.org/fhir/DSTU2/references.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Organization, [:search, :read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_reference_resolutions(@organization)
  
      end
      
    end
  end
end