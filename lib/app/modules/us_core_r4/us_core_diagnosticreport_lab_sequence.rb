
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
      
      test 'Demonstrates that the server can supply must supported elements' do
        metadata {
          id '13'
          link 'https://build.fhir.org/ig/HL7/US-Core-R4/general-guidance.html/#must-support'
          desc %(
          )
          versions :r4
        }
        
            skip 'Could not find DiagnosticReport.status in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.status") || can_resolve_path(@diagnosticreport, 'status')
            @instance.must_support_confirmed += 'DiagnosticReport.status'
        
            skip 'Could not find DiagnosticReport.category in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.category") || can_resolve_path(@diagnosticreport, 'category')
            @instance.must_support_confirmed += 'DiagnosticReport.category'
        
            skip 'Could not find DiagnosticReport.code in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.code") || can_resolve_path(@diagnosticreport, 'code')
            @instance.must_support_confirmed += 'DiagnosticReport.code'
        
            skip 'Could not find DiagnosticReport.subject in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.subject") || can_resolve_path(@diagnosticreport, 'subject')
            @instance.must_support_confirmed += 'DiagnosticReport.subject'
        
            skip 'Could not find DiagnosticReport.effective[x] in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.effective[x]") || can_resolve_path(@diagnosticreport, 'effectivedateTime')
            @instance.must_support_confirmed += 'DiagnosticReport.effective[x]'
        
            skip 'Could not find DiagnosticReport.effective[x] in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.effective[x]") || can_resolve_path(@diagnosticreport, 'effectivePeriod')
            @instance.must_support_confirmed += 'DiagnosticReport.effective[x]'
        
            skip 'Could not find DiagnosticReport.issued in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.issued") || can_resolve_path(@diagnosticreport, 'issued')
            @instance.must_support_confirmed += 'DiagnosticReport.issued'
        
            skip 'Could not find DiagnosticReport.performer in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.performer") || can_resolve_path(@diagnosticreport, 'performer')
            @instance.must_support_confirmed += 'DiagnosticReport.performer'
        
            skip 'Could not find DiagnosticReport.result in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.result") || can_resolve_path(@diagnosticreport, 'result')
            @instance.must_support_confirmed += 'DiagnosticReport.result'
        
            skip 'Could not find DiagnosticReport.media in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.media") || can_resolve_path(@diagnosticreport, 'media')
            @instance.must_support_confirmed += 'DiagnosticReport.media'
        
            skip 'Could not find DiagnosticReport.presentedForm in the provided resource' unless (@instance.must_support_confirmed.include? "DiagnosticReport.presentedForm") || can_resolve_path(@diagnosticreport, 'presentedForm')
            @instance.must_support_confirmed += 'DiagnosticReport.presentedForm'
        
        @instance.save!
  
      end
      
      test 'DiagnosticReport resources associated with Patient conform to Argonaut profiles' do
        metadata {
          id '14'
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
          id '15'
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