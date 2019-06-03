
module Inferno
  module Sequence
    class UsCoreR4DiagnosticreportLabSequence < SequenceBase

      group 'US Core R4 Profile Conformance'

      title 'US Core R4 DiagnosticreportLab Tests'

      description 'Verify that DiagnosticReport resources on the FHIR server follow the Argonaut Data Query Implementation Guide'

      test_id_prefix 'DiagnosticReport' # change me

      requires :token, :patient_id
      conformance_supports :DiagnosticReport

      
        def validate_resource_item (resource, property, value)
          case property
          
          when 'patient'
            assert (resource&.subject && resource.subject.reference.include?(value)), "patient on resource does not match patient requested"
        
          when 'status'
            assert resource&.status != nil && resource&.status == value, "status on resource did not match status requested"
        
          when 'category'
            codings = resource&.category&.coding
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
        returned will be checked for consistency against the [DiagnosticreportLab Argonaut Profile](https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-diagnosticreport-lab)

      )

      @resources_found = false
      
      test 'Server rejects DiagnosticReport search without authorization' do
        metadata {
          id '01'
          link 'http://www.fhir.org/guides/argonaut/r2/Conformance-server.html'
          desc %(
          )
          versions :r4
        }
        
        @client.set_no_auth
        skip 'Could not verify this functionality when bearer token is not set' if @instance.token.blank?

        reply = get_resource_by_params(versioned_resource_class('DiagnosticReport'), {patient: @instance.patient_id})
        @client.set_bearer_token(@instance.token)
        assert_response_unauthorized reply
  
      end
      
      test 'Server returns expected results from DiagnosticReport search by patient+category' do
        metadata {
          id '02'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        
        search_params = {patient: @instance.patient_id, category: "LAB"}
      
        reply = get_resource_by_params(versioned_resource_class('DiagnosticReport'), search_params)
        assert_response_ok(reply)
        assert_bundle_response(reply)

        resource_count = reply.try(:resource).try(:entry).try(:length) || 0
        if resource_count > 0
          @resources_found = true
        end

        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        @diagnosticreport = reply.try(:resource).try(:entry).try(:first).try(:resource)
        validate_search_reply(versioned_resource_class('DiagnosticReport'), reply, search_params)
        save_resource_ids_in_bundle(versioned_resource_class('DiagnosticReport'), reply)
    
      end
      
      test 'Server returns expected results from DiagnosticReport search by patient+code' do
        metadata {
          id '03'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@diagnosticreport.nil?, 'Expected valid DiagnosticReport resource to be present'
        
        patient_val = @instance.patient_id
        code_val = @diagnosticreport&.code&.coding&.first&.code
        search_params = {'patient': patient_val, 'code': code_val}
  
        reply = get_resource_by_params(versioned_resource_class('DiagnosticReport'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DiagnosticReport search by patient+category+date' do
        metadata {
          id '04'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@diagnosticreport.nil?, 'Expected valid DiagnosticReport resource to be present'
        
        patient_val = @instance.patient_id
        category_val = @diagnosticreport&.category&.coding&.first&.code
        date_val = @diagnosticreport&.effectiveDateTime
        search_params = {'patient': patient_val, 'category': category_val, 'date': date_val}
  
        reply = get_resource_by_params(versioned_resource_class('DiagnosticReport'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DiagnosticReport search by patient+category' do
        metadata {
          id '05'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@diagnosticreport.nil?, 'Expected valid DiagnosticReport resource to be present'
        
        search_params = {patient: @instance.patient_id, category: "LAB"}
      
        reply = get_resource_by_params(versioned_resource_class('DiagnosticReport'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DiagnosticReport search by patient+code+date' do
        metadata {
          id '06'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@diagnosticreport.nil?, 'Expected valid DiagnosticReport resource to be present'
        
        patient_val = @instance.patient_id
        code_val = @diagnosticreport&.code&.coding&.first&.code
        date_val = @diagnosticreport&.effectiveDateTime
        search_params = {'patient': patient_val, 'code': code_val, 'date': date_val}
  
        reply = get_resource_by_params(versioned_resource_class('DiagnosticReport'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DiagnosticReport search by patient+status' do
        metadata {
          id '07'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@diagnosticreport.nil?, 'Expected valid DiagnosticReport resource to be present'
        
        patient_val = @instance.patient_id
        status_val = @diagnosticreport&.status
        search_params = {'patient': patient_val, 'status': status_val}
  
        reply = get_resource_by_params(versioned_resource_class('DiagnosticReport'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'Server returns expected results from DiagnosticReport search by patient+category+date' do
        metadata {
          id '08'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        assert !@diagnosticreport.nil?, 'Expected valid DiagnosticReport resource to be present'
        
        patient_val = @instance.patient_id
        category_val = @diagnosticreport&.category&.coding&.first&.code
        date_val = @diagnosticreport&.effectiveDateTime
        search_params = {'patient': patient_val, 'category': category_val, 'date': date_val}
  
        reply = get_resource_by_params(versioned_resource_class('DiagnosticReport'), search_params)
        assert_response_ok(reply)
    
      end
      
      test 'DiagnosticReport create resource supported' do
        metadata {
          id '09'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DiagnosticReport, [:create])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_create_reply(@diagnosticreport, versioned_resource_class('DiagnosticReport'))
  
      end
      
      test 'DiagnosticReport read resource supported' do
        metadata {
          id '10'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DiagnosticReport, [:read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_read_reply(@diagnosticreport, versioned_resource_class('DiagnosticReport'))
  
      end
      
      test 'DiagnosticReport vread resource supported' do
        metadata {
          id '11'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DiagnosticReport, [:vread])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_vread_reply(@diagnosticreport, versioned_resource_class('DiagnosticReport'))
  
      end
      
      test 'DiagnosticReport history resource supported' do
        metadata {
          id '12'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/CapabilityStatement-us-core-server.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DiagnosticReport, [:history])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_history_reply(@diagnosticreport, versioned_resource_class('DiagnosticReport'))
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.status' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.status" then
          assert can_resolve_path(@diagnosticreport, 'status'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.status,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.category' do
        metadata {
          id '14'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.category" then
          assert can_resolve_path(@diagnosticreport, 'category'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.category,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.code' do
        metadata {
          id '15'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.code" then
          assert can_resolve_path(@diagnosticreport, 'code'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.code,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.subject' do
        metadata {
          id '16'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.subject" then
          assert can_resolve_path(@diagnosticreport, 'subject'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.subject,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.effective[x]' do
        metadata {
          id '17'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.effective[x]" then
          assert can_resolve_path(@diagnosticreport, 'effectivedateTime') || can_resolve_path(@diagnosticreport, 'effectivePeriod'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.effective[x],"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.issued' do
        metadata {
          id '18'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.issued" then
          assert can_resolve_path(@diagnosticreport, 'issued'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.issued,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.performer' do
        metadata {
          id '19'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.performer" then
          assert can_resolve_path(@diagnosticreport, 'performer'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.performer,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.result' do
        metadata {
          id '20'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.result" then
          assert can_resolve_path(@diagnosticreport, 'result'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.result,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.media' do
        metadata {
          id '21'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.media" then
          assert can_resolve_path(@diagnosticreport, 'media'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.media,"
          @instance.save!
        end
  
      end
      
      test 'Demonstrates that the server can supply DiagnosticReport.presentedForm' do
        metadata {
          id '22'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
        if !@instance.must_support_confirmed.include? "DiagnosticReport.presentedForm" then
          assert can_resolve_path(@diagnosticreport, 'presentedForm'), 'Could not find must supported element in the provided resource'
          @instance.must_support_confirmed += "DiagnosticReport.presentedForm,"
          @instance.save!
        end
  
      end
      
      test 'DiagnosticReport resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '23'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/StructureDefinition-us-core-diagnosticreport-lab.json'
          desc %(
          )
          versions :r4
        }
        
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found
        test_resources_against_profile('DiagnosticReport')
  
      end
      
      test 'All references can be resolved' do
        metadata {
          id '24'
          link 'https://www.hl7.org/fhir/DSTU2/references.html'
          desc %(
          )
          versions :r4
        }
        
        skip_if_not_supported(:DiagnosticReport, [:search, :read])
        skip 'No resources appear to be available for this patient. Please use patients with more information.' unless @resources_found

        validate_reference_resolutions(@diagnosticreport)
  
      end
      
    end
  end
end