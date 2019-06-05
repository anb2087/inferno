
module Inferno
  module Sequence
    class UsCoreR4PatientSequence < SequenceBase

      group 'US Core R4 Profile Conformance'

      title 'US Core R4 Patient Tests'

      description 'Verify that Patient resources on the FHIR server follow the Argonaut Data Query Implementation Guide'

      test_id_prefix 'Patient' # change me

      requires :token, :patient_id
      conformance_supports :Patient

      
        def validate_resource_item (resource, property, value)
          case property
          
          when '_id'
            assert resource&.id != nil && resource&.id == value, "_id on resource did not match _id requested"
        
          when 'birthdate'
        
          when 'family'
            assert resource&.name&.family != nil && resource&.name&.family == value, "family on resource did not match family requested"
        
          when 'gender'
            assert resource&.gender != nil && resource&.gender == value, "gender on resource did not match gender requested"
        
          when 'given'
            assert resource&.name&.given != nil && resource&.name&.given == value, "given on resource did not match given requested"
        
            when 'name'
              found = resource.name.any? do |name|
                name&.text&.include?(value) ||
                  name&.family.include?(value) || 
                  name&.given.any{|given| given&.include?(value)} ||
                  name&.prefix.any{|prefix| prefix&.include?(value)} ||
                  name&.suffix.any{|suffix| suffix&.include?(value)}
              end
              assert found, "name on resource does not match name requested"
          
          end
        end
    

      details %(
        
        The #{title} Sequence tests `#{title.gsub(/\s+/,"")}` resources associated with the provided patient.  The resources
        returned will be checked for consistency against the [Patient Argonaut Profile](https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-patient)

      )

      @resources_found = false
      
      test 'Server rejects Patient search without authorization' do
        metadata {
          id '01'
          link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
          desc %(
          )
          versions :r4
        }
        
        @client.set_no_auth
        skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?

        reply = get_resource_by_params(versioned_resource_class('Patient'), {patient: @instance.patient_id})
        @client.set_bearer_token(@instance.token)
        assert_response_unauthorized reply
  
      end
      
      test 'Server returns expected results from Patient search by _id' do
        metadata {
          id '02'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        
        search_params = {'_id': @instance.patient_id}
      
        reply = get_resource_by_params(versioned_resource_class('Patient'), search_params)
        assert_response_ok(reply)
        assert_bundle_response(reply)

        resource_count = reply.try(:resource).try(:entry).try(:length) || 0
        if resource_count > 0
          @resources_found = true
        end

        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        @patient = reply.try(:resource).try(:entry).try(:first).try(:resource)
        validate_search_reply(versioned_resource_class('Patient'), reply, search_params)
        save_resource_ids_in_bundle(versioned_resource_class('Patient'), reply)
    
      end
      
      test 'Server returns expected results from Patient search by identifier' do
        metadata {
          id '03'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@patient.nil?, 'Expected valid Patient resource to be present'
        
        identifier_val = @patient&.identifier.first&.value
        search_params = {'identifier': identifier_val}
  
        reply = get_resource_by_params(versioned_resource_class('Patient'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Patient search by name' do
        metadata {
          id '04'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@patient.nil?, 'Expected valid Patient resource to be present'
        
        name_val = @patient&.name.first&.family
        search_params = {'name': name_val}
  
        reply = get_resource_by_params(versioned_resource_class('Patient'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Patient search by birthdate+name' do
        metadata {
          id '05'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@patient.nil?, 'Expected valid Patient resource to be present'
        
        birthdate_val = @patient&.birthDate
        name_val = @patient&.name.first&.family
        search_params = {'birthdate': birthdate_val, 'name': name_val}
  
        reply = get_resource_by_params(versioned_resource_class('Patient'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Patient search by gender+name' do
        metadata {
          id '06'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@patient.nil?, 'Expected valid Patient resource to be present'
        
        gender_val = @patient&.gender
        name_val = @patient&.name.first&.family
        search_params = {'gender': gender_val, 'name': name_val}
  
        reply = get_resource_by_params(versioned_resource_class('Patient'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Patient search by family+gender' do
        metadata {
          id '07'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@patient.nil?, 'Expected valid Patient resource to be present'
        
        family_val = @patient&.name.first&.family
        gender_val = @patient&.gender
        search_params = {'family': family_val, 'gender': gender_val}
  
        reply = get_resource_by_params(versioned_resource_class('Patient'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from Patient search by birthdate+family' do
        metadata {
          id '08'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@patient.nil?, 'Expected valid Patient resource to be present'
        
        birthdate_val = @patient&.birthDate
        family_val = @patient&.name.first&.family
        search_params = {'birthdate': birthdate_val, 'family': family_val}
  
        reply = get_resource_by_params(versioned_resource_class('Patient'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Patient read resource supported' do
        metadata {
          id '09'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Patient, [:read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_read_reply(@patient, versioned_resource_class('Patient'))
  
      end
      
      test 'Patient vread resource supported' do
        metadata {
          id '10'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Patient, [:vread])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_vread_reply(@patient, versioned_resource_class('Patient'))
  
      end
      
      test 'Patient history resource supported' do
        metadata {
          id '11'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Patient, [:history])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_history_reply(@patient, versioned_resource_class('Patient'))
  
      end
      
      test 'Demonstrates that the server can supply must supported elements' do
        metadata {
          id '12'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
            skip 'Could  not find Patient.extension:race in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.extension:race") || (can_resolve_path(@patient, 'extension') && @patient.extension.any? {|extension| extension.url == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-race'})
            @instance.must_support_confirmed += 'Patient.extension:race'
        
            skip 'Could  not find Patient.extension:ethnicity in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.extension:ethnicity") || (can_resolve_path(@patient, 'extension') && @patient.extension.any? {|extension| extension.url == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-ethnicity'})
            @instance.must_support_confirmed += 'Patient.extension:ethnicity'
        
            skip 'Could  not find Patient.extension:birthsex in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.extension:birthsex") || (can_resolve_path(@patient, 'extension') && @patient.extension.any? {|extension| extension.url == 'http://hl7.org/fhir/us/core/StructureDefinition/us-core-birthsex'})
            @instance.must_support_confirmed += 'Patient.extension:birthsex'
        
            skip 'Could not find Patient.identifier in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.identifier") || can_resolve_path(@patient, 'identifier')
            @instance.must_support_confirmed += 'Patient.identifier'
        
            skip 'Could not find Patient.identifier.system in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.identifier.system") || can_resolve_path(@patient, 'identifier.system')
            @instance.must_support_confirmed += 'Patient.identifier.system'
        
            skip 'Could not find Patient.identifier.value in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.identifier.value") || can_resolve_path(@patient, 'identifier.value')
            @instance.must_support_confirmed += 'Patient.identifier.value'
        
            skip 'Could not find Patient.name in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.name") || can_resolve_path(@patient, 'name')
            @instance.must_support_confirmed += 'Patient.name'
        
            skip 'Could not find Patient.name.family in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.name.family") || can_resolve_path(@patient, 'name.family')
            @instance.must_support_confirmed += 'Patient.name.family'
        
            skip 'Could not find Patient.name.given in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.name.given") || can_resolve_path(@patient, 'name.given')
            @instance.must_support_confirmed += 'Patient.name.given'
        
            skip 'Could not find Patient.telecom in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.telecom") || can_resolve_path(@patient, 'telecom')
            @instance.must_support_confirmed += 'Patient.telecom'
        
            skip 'Could not find Patient.telecom.system in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.telecom.system") || can_resolve_path(@patient, 'telecom.system')
            @instance.must_support_confirmed += 'Patient.telecom.system'
        
            skip 'Could not find Patient.telecom.value in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.telecom.value") || can_resolve_path(@patient, 'telecom.value')
            @instance.must_support_confirmed += 'Patient.telecom.value'
        
            skip 'Could not find Patient.gender in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.gender") || can_resolve_path(@patient, 'gender')
            @instance.must_support_confirmed += 'Patient.gender'
        
            skip 'Could not find Patient.birthDate in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.birthDate") || can_resolve_path(@patient, 'birthDate')
            @instance.must_support_confirmed += 'Patient.birthDate'
        
            skip 'Could not find Patient.address in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.address") || can_resolve_path(@patient, 'address')
            @instance.must_support_confirmed += 'Patient.address'
        
            skip 'Could not find Patient.address.line in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.address.line") || can_resolve_path(@patient, 'address.line')
            @instance.must_support_confirmed += 'Patient.address.line'
        
            skip 'Could not find Patient.address.city in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.address.city") || can_resolve_path(@patient, 'address.city')
            @instance.must_support_confirmed += 'Patient.address.city'
        
            skip 'Could not find Patient.address.state in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.address.state") || can_resolve_path(@patient, 'address.state')
            @instance.must_support_confirmed += 'Patient.address.state'
        
            skip 'Could not find Patient.address.postalCode in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.address.postalCode") || can_resolve_path(@patient, 'address.postalCode')
            @instance.must_support_confirmed += 'Patient.address.postalCode'
        
            skip 'Could not find Patient.communication in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.communication") || can_resolve_path(@patient, 'communication')
            @instance.must_support_confirmed += 'Patient.communication'
        
            skip 'Could not find Patient.communication.language in the provided resource' unless (@instance.must_support_confirmed.include? "Patient.communication.language") || can_resolve_path(@patient, 'communication.language')
            @instance.must_support_confirmed += 'Patient.communication.language'
        
        @instance.save!
  
      end
      
      test 'Patient resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-patient.json'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        test_resources_against_profile('Patient')
  
      end
      
      test 'All references can be resolved' do
        metadata {
          id '14'
          link 'https://www.hl7.org/fhir/DSTU2/references.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:Patient, [:search, :read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_reference_resolutions(@patient)
  
      end
      
    end
  end
end