
module Inferno
  module Sequence
    class UsCoreR4DocumentreferenceSequence < SequenceBase

      group 'US Core R4 Profile Conformance'

      title 'US Core R4 Documentreference Tests'

      description 'Verify that DocumentReference resources on the FHIR server follow the Argonaut Data Query Implementation Guide'

      test_id_prefix 'DocumentReference' # change me

      requires :token, :patient_id
      conformance_supports :DocumentReference

      
        def validate_resource_item (resource, property, value)
          case property
          
          when 'patient'
            assert (resource&.subject && resource.subject.reference.include?(value)), "patient on resource does not match patient requested"
        
          when '_id'
            assert resource&.id != nil && resource&.id == value, "_id on resource did not match _id requested"
        
          when 'status'
            assert resource&.status != nil && resource&.status == value, "status on resource did not match status requested"
        
          when 'category'
            codings = resource&.category.first&.coding
            assert !codings.nil?, "category on resource did not match category requested"
            assert codings.any? {|coding| !coding.try(:code).nil? && coding.try(:code) == value}, "category on resource did not match category requested"
        
          when 'type'
            codings = resource&.type&.coding
            assert !codings.nil?, "type on resource did not match type requested"
            assert codings.any? {|coding| !coding.try(:code).nil? && coding.try(:code) == value}, "type on resource did not match type requested"
        
          when 'date'
        
          when 'period'
        
          end
        end
    

      details %(
        
        The #{title} Sequence tests `#{title.gsub(/\s+/,"")}` resources associated with the provided patient.  The resources
        returned will be checked for consistency against the [Documentreference Argonaut Profile](https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-documentreference)

      )

      @resources_found = false
      
      test 'Server rejects DocumentReference search without authorization' do
        metadata {
          id '01'
          link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
          desc %(
          )
          versions :r4
        }
        
        @client.set_no_auth
        skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?

        reply = get_resource_by_params(versioned_resource_class('DocumentReference'), {patient: @instance.patient_id})
        @client.set_bearer_token(@instance.token)
        assert_response_unauthorized reply
  
      end
      
      test 'Server returns expected results from DocumentReference search by patient' do
        metadata {
          id '02'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        
        patient_val = @instance.patient_id
        search_params = {'patient': patient_val}
  
        reply = get_resource_by_params(versioned_resource_class('DocumentReference'), search_params)
        assert_response_ok(reply)
        assert_bundle_response(reply)

        resource_count = reply.try(:resource).try(:entry).try(:length) || 0
        if resource_count > 0
          @resources_found = true
        end

        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        @documentreference = reply.try(:resource).try(:entry).try(:first).try(:resource)
        validate_search_reply(versioned_resource_class('DocumentReference'), reply, search_params)
        save_resource_ids_in_bundle(versioned_resource_class('DocumentReference'), reply)
    
      end
      
      test 'Server returns expected results from DocumentReference search by _id' do
        metadata {
          id '03'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@documentreference.nil?, 'Expected valid DocumentReference resource to be present'
        
        _id_val = @documentreference&.id
        search_params = {'_id': _id_val}
  
        reply = get_resource_by_params(versioned_resource_class('DocumentReference'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DocumentReference search by patient+category' do
        metadata {
          id '04'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@documentreference.nil?, 'Expected valid DocumentReference resource to be present'
        
        patient_val = @instance.patient_id
        category_val = @documentreference&.category.first&.coding&.first&.code
        search_params = {'patient': patient_val, 'category': category_val}
  
        reply = get_resource_by_params(versioned_resource_class('DocumentReference'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DocumentReference search by patient+category+date' do
        metadata {
          id '05'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@documentreference.nil?, 'Expected valid DocumentReference resource to be present'
        
        patient_val = @instance.patient_id
        category_val = @documentreference&.category.first&.coding&.first&.code
        date_val = @documentreference&.date
        search_params = {'patient': patient_val, 'category': category_val, 'date': date_val}
  
        reply = get_resource_by_params(versioned_resource_class('DocumentReference'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DocumentReference search by patient+type' do
        metadata {
          id '06'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@documentreference.nil?, 'Expected valid DocumentReference resource to be present'
        
        patient_val = @instance.patient_id
        type_val = @documentreference&.type&.coding&.first&.code
        search_params = {'patient': patient_val, 'type': type_val}
  
        reply = get_resource_by_params(versioned_resource_class('DocumentReference'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DocumentReference search by patient+status' do
        metadata {
          id '07'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@documentreference.nil?, 'Expected valid DocumentReference resource to be present'
        
        patient_val = @instance.patient_id
        status_val = @documentreference&.status
        search_params = {'patient': patient_val, 'status': status_val}
  
        reply = get_resource_by_params(versioned_resource_class('DocumentReference'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DocumentReference search by patient+type+period' do
        metadata {
          id '08'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@documentreference.nil?, 'Expected valid DocumentReference resource to be present'
        
        patient_val = @instance.patient_id
        type_val = @documentreference&.type&.coding&.first&.code
        period_val = @documentreference&.context&.period&.start
        search_params = {'patient': patient_val, 'type': type_val, 'period': period_val}
  
        reply = get_resource_by_params(versioned_resource_class('DocumentReference'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'DocumentReference create resource supported' do
        metadata {
          id '09'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DocumentReference, [:create])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_create_reply(@documentreference, versioned_resource_class('DocumentReference'))
  
      end
      
      test 'DocumentReference read resource supported' do
        metadata {
          id '10'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DocumentReference, [:read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_read_reply(@documentreference, versioned_resource_class('DocumentReference'))
  
      end
      
      test 'DocumentReference vread resource supported' do
        metadata {
          id '11'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DocumentReference, [:vread])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_vread_reply(@documentreference, versioned_resource_class('DocumentReference'))
  
      end
      
      test 'DocumentReference history resource supported' do
        metadata {
          id '12'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DocumentReference, [:history])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_history_reply(@documentreference, versioned_resource_class('DocumentReference'))
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.identifier' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.identifier" then
          assert can_resolve_path(@documentreference, 'identifier'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.identifier,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.status' do
        metadata {
          id '14'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.status" then
          assert can_resolve_path(@documentreference, 'status'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.status,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.type' do
        metadata {
          id '15'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.type" then
          assert can_resolve_path(@documentreference, 'type'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.type,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.category' do
        metadata {
          id '16'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.category" then
          assert can_resolve_path(@documentreference, 'category'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.category,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.subject' do
        metadata {
          id '17'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.subject" then
          assert can_resolve_path(@documentreference, 'subject'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.subject,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.date' do
        metadata {
          id '18'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.date" then
          assert can_resolve_path(@documentreference, 'date'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.date,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.author' do
        metadata {
          id '19'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.author" then
          assert can_resolve_path(@documentreference, 'author'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.author,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.custodian' do
        metadata {
          id '20'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.custodian" then
          assert can_resolve_path(@documentreference, 'custodian'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.custodian,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.content' do
        metadata {
          id '21'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.content" then
          assert can_resolve_path(@documentreference, 'content'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.content,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.content.attachment' do
        metadata {
          id '22'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.content.attachment" then
          assert can_resolve_path(@documentreference, 'content.attachment'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.content.attachment,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.content.attachment.contentType' do
        metadata {
          id '23'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.content.attachment.contentType" then
          assert can_resolve_path(@documentreference, 'content.attachment.contentType'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.content.attachment.contentType,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.content.attachment.data' do
        metadata {
          id '24'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.content.attachment.data" then
          assert can_resolve_path(@documentreference, 'content.attachment.data'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.content.attachment.data,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.content.attachment.url' do
        metadata {
          id '25'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.content.attachment.url" then
          assert can_resolve_path(@documentreference, 'content.attachment.url'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.content.attachment.url,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.content.format' do
        metadata {
          id '26'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.content.format" then
          assert can_resolve_path(@documentreference, 'content.format'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.content.format,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.context' do
        metadata {
          id '27'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.context" then
          assert can_resolve_path(@documentreference, 'context'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.context,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.context.encounter' do
        metadata {
          id '28'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.context.encounter" then
          assert can_resolve_path(@documentreference, 'context.encounter'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.context.encounter,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DocumentReference.context.period' do
        metadata {
          id '29'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DocumentReference.context.period" then
          assert can_resolve_path(@documentreference, 'context.period'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DocumentReference.context.period,"
          @instance.save!
        end
  
      end
      
      test 'DocumentReference resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '30'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-documentreference.json'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        test_resources_against_profile('DocumentReference')
  
      end
      
      test 'All references can be resolved' do
        metadata {
          id '31'
          link 'https://www.hl7.org/fhir/DSTU2/references.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DocumentReference, [:search, :read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_reference_resolutions(@documentreference)
  
      end
      
    end
  end
end