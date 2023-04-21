# sfTools
Salesforce Tools for quick development and best practices

## Data Factory

/force-app/main/default/classes/DataFactory.cls

Example: 

    Ar_Data__c ar2 = DataFactory.anArData()
    .withAccount(acc.Id)
    .build();
    insert ar2;
