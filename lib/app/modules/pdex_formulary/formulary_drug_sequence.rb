module Inferno
    module Sequence
        class FormularyDrugSequence < SequenceBase

            group 'Formulary Drug'
            
            title 'Formulary Drug Tests'

            description 'Verify input conforms to standards'

            test_id_prefix 'FDS'

            conformance_supports :FDS

            requires :url

            @formularydrug = nil
            @total= nil
            @profile= nil
            @profileold= nil

            test 'Able to retrieve all Medication Knowledge resources' do
      
                metadata{
                  id '01'
                  desc %(
                    Tests if the FHIR server will return every medication knowledge the bundles say it will
                  )
                }
        
                total = how_many(FHIR::MedicationKnowledge)
                @formularydrug = get_all_resources(FHIR::MedicationKnowledge)
                @formularydrug.each do |q|
                  assert q.class.eql?(FHIR::MedicationKnowledge), "All coverage plans must be instances of FHIR::MedicationKnoeldge, not " + q.class.to_s
                end
                assert @formularydrug.length == total, "Server claimed to hold " + total.to_s + " Medication Knowledge, actually reads in " + @formularydrug.length.to_s
        
              end

            test 'Medication Knowledge do not violate HL7 requirements' do
        
                metadata{
                  id '02'
                  desc %(
                    Tests if the Medication Knowledge from the FHIR server are valid according to HL7's definition of a Medication Knowledge
                  )
                }
        
                errors = check_validity(@formularydrug)
                assert errors.empty?, errors.to_s
        
              end
      

            test 'Medication Knowledge specified as Formulary Drug conform to Formulary Drug specifications' do 
                metadata {
                    id '03'
                    desc 'Check cardinality of formulary drug specifications'
                }
                @profile= 'http://hl7.org/fhir/us/Davinci-drug-formulary/StructureDefinition/usdf-FormularyDrug'
                @profileold= 'https://api-v8-r4.hspconsortium.org/DrugFormulary1/open/StructureDefinition/usdrugformulary-FormularyDrug'
                errors= check_profiles(nil, FHIR::MedicationKnowledge, @profile)
                assert errors.empty?, errors.to_s
            end
        end
    end
end
