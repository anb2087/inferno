module Inferno
    module Sequence
        class CoveragePlanSequence < SequenceBase

            group 'Coverage Plan'
            
            title 'Coverage Plan Tests'

            description 'Verify input conforms to standards'

            test_id_prefix 'CPS'

            conformance_supports :CPS

            requires :url

            ##
            #@profileold refers to the may 19th version of the IG
            #@profile is the more recent one

            @coverageplan = nil
            @total= nil
            @profile= nil
            @profileold= nil
    

            test 'Able to retrieve all List resources' do
      
                metadata{
                  id '01'
                  desc %(
                    Tests if the FHIR server will return every Coverage PLan the bundles say it will
                  )
                }
                @profile= 'http://hl7.org/fhir/us/Davinci-drug-formulary/StructureDefinition/usdf-CoveragePlan'
                @profileold= 'https://api-v8-r4.hspconsortium.org/DrugFormulary1/open/StructureDefinition/usdrugformulary-CoveragePlan'
                total = how_many(FHIR::List)
                @coverageplan = get_all_resources(FHIR::List)
                @coverageplan.each do |q|
                  assert q.class.eql?(FHIR::List), "All Lists must be instances of FHIR::List, not " + q.class.to_s
                end
                assert @coverageplan.length == total, "Server claimed to hold " + total.to_s + " lists, actually reads in " + @coverageplan.length.to_s
        
              end

            test 'Lists do not violate HL7 requirements' do
        
                metadata{
                  id '02'
                  desc %(
                    Tests if List resources from the FHIR server are valid according to HL7's definition of a List
                  )
                }
        
                errors = check_validity(@coverageplan)
                assert errors.empty?, errors.to_s
        
              end
      

            test 'Lists specified as Coverage Plans conform to Coverage Plan specifications' do 
                metadata {
                    id '03'
                    desc 'Check cardinality of coverage plan specifications'
                }
                errors= check_profiles(nil, FHIR::List, @profileold)
                assert errors.empty?, errors.to_s
            end
        end
    end
end
