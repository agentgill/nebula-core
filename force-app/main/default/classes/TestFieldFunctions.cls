/**
 * @author aidan@nebulaconsulting.co.uk
 * @date 2019-03-04
 * @description Some standard implementations of TestFieldFunction
 */

global class TestFieldFunctions {

    global abstract class TestFieldFunctionWithParent implements TestFieldFunction {
        global TestRecordGenerator parentGenerator;

        global TestFieldFunction setParentGenerator(TestRecordGenerator parentGenerator) {
            this.parentGenerator = parentGenerator;
            return this;
        }
    }

    global class AppendRandomNumber extends TestFieldFunctionWithParent {
        global Object getValue(String fieldName, Object value) {
            return value == null ? value : (value + String.valueOf(Math.random()));
        }
    }

    global class GetStandardPriceBookId extends TestFieldFunctionWithParent {
        global Object getValue(String fieldName, Object value) {
            return Test.getStandardPricebookId();
        }
    }

    global class CreateRecord extends TestFieldFunctionWithParent {

        global String sObjectType;
        global String variant;
        global String variantParameter;
        global Integer numberOfRecords;

        global Object getValue(String fieldName, Object value) {
            SObject targetInstance = (SObject) TypeLoader.getType((String) sObjectType).newInstance();
            if(variantParameter != null) {
                variant = (String)parentGenerator.getParameter(variantParameter);
            }

            TestRecordSource.GetBuilder builder = parentGenerator.parentRecordSource
                    .getRecord(targetInstance.getSObjectType())
                    .asVariant(variant);
            if (numberOfRecords == null) {
                return builder.withInsert().Id;
            } else {
                return builder.withInsert(numberOfRecords);
            }
        }
    }

    global class GetRecordTypeId extends TestFieldFunctionWithParent {

        global String sObjectType;
        global String developerName;

        global Object getValue(String fieldName, Object value) {
            return NamedSObjectCache.getRecordType(
                    sObjectType,
                    developerName
            ).Id;
        }
    }

    global class Now extends TestFieldFunctionWithParent {

        global Integer addDays;
        global Integer addMinutes;

        global Object getValue(String fieldName, Object value) {
            Datetime returnValue = Datetime.now();
            if(addDays != null) {
                returnValue = returnValue.addDays(addDays);
            }
            if(addMinutes != null) {
                returnValue = returnValue.addMinutes(addMinutes);
            }
            return returnValue;
        }
    }

    global class Today extends TestFieldFunctionWithParent {

        global Integer addDays;

        global Object getValue(String fieldName, Object value) {
            Date returnValue = Date.today();
            if(addDays != null) {
                returnValue = returnValue.addDays(addDays);
            }
            return returnValue;
        }
    }

    global class Increment extends TestFieldFunctionWithParent {

        global Decimal accumulator;
        global Decimal increment;

        global Object getValue(String fieldName, Object value) {
            Decimal result =  (Decimal)value + accumulator;
            accumulator += increment;
            return result;
        }
    }

    global class ReadParameter extends TestFieldFunctionWithParent {

        global String parameterName;

        global Object getValue(String fieldName, Object value) {
            parameterName = parameterName == null ? fieldName : parameterName;
            if(parentGenerator.hasParameter(parameterName)) {
                return parentGenerator.getParameter(parameterName);
            } else {
                return value;
            }
        }
    }
}