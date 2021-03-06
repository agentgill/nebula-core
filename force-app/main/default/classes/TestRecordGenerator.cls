/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 2019-03-01
 */

global inherited sharing abstract class TestRecordGenerator {

    global TestRecordSource parentRecordSource {get; private set;}
    global Test_Record_Generator__mdt metadata {get; private set;}
    global List<Test_Record_Generator_Field__mdt> metadataFields {get; private set;}
    protected Map<String, Object> parameters {
        get {
            if(parameters == null) {
                parameters = new Map<String, Object>();
            }
            return parameters;
        }
        set;
    }

    global Object getParameter(String name) {
        return parameters == null ? null : parameters.get(name);
    }

    global Boolean hasParameter(String name) {
        return parameters.containsKey(name);
    }

    public void setup(TestRecordSource parentRecordSource, Test_Record_Generator__mdt metadata, List<Test_Record_Generator_Field__mdt> metadataFields) {
        this.parentRecordSource = parentRecordSource;
        this.metadata = metadata;
        this.metadataFields = metadataFields;
    }

    global SObject getRecordWithoutInsert(Map<String, Object> parameters) {
        this.parameters = parameters;
        return getRecordWithoutInsert();
    }

    global abstract SObject getRecordWithoutInsert();

    global virtual List<SObject> getRecordsWithoutInsert(Integer numberOfRecords, Map<String, Object> params) {
        List<SObject> returnVal = new List<SObject>();
        for(Integer i=0; i < numberOfRecords; i++) {
            returnVal.add(getRecordWithoutInsert(params));
        }
        return returnVal;
    }

    global List<SObject> getRecordsWithInsert(Integer numberOfRecords, Map<String, Object> params) {
        if(record == null) {
            record = getRecordsWithoutInsert(numberOfRecords, params);
            try {
                insert record;
            } catch (Exception e) {
                throw new TestRecordGeneratorException('Exception creating test record '
                        + metadata.DeveloperName
                        + '\n'
                        + e.getMessage());
            }

        }
        return record;
    }

    private List<SObject> record;

    global virtual SObject getRecordWithInsert(Map<String, Object> params) {
        if(record == null) {
            record = new List<SObject> { getRecordWithoutInsert(params) };
            try {
                insert record;
            } catch (Exception e) {
                throw new TestRecordGeneratorException('Exception creating test record '
                        + metadata.DeveloperName
                        + '\n'
                        + e.getMessage());
            }

        }
        return record[0];
    }

    global virtual void setRecord(SObject record) {
        this.record = new List<SObject>{ record };
    }
    global virtual void setRecords(List<SObject> records) {
        this.record = records;
    }
}