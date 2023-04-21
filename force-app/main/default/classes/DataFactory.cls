/**
 * @description       : Test Data Factory
 * @author            : Giovanni Ulloque
 * @last modified on  : 04-17-2023
 * @last modified by  : Giovanni Ulloque
 **/
@isTest
public with sharing class DataFactory {
  /*------------------------------------------------------------------------
	            AccountBuilderStart
	------------------------------------------------------------------------*/
  public class AccountBuilder {
    private Account obj = new Account(Name = 'Test Account');

    public AccountBuilder withName(String value) {
      obj.Name = value;
      return this;
    }

    public AccountBuilder withOwner(Id value) {
      obj.OwnerId = value;
      return this;
    }
    public AccountBuilder withType(String value) {
      obj.Type = value;
      return this;
    }
    public AccountBuilder withCompanyVertical(String value) {
      obj.Company_Vertical__c = value;
      return this;
    }

    public Account build() {
      return obj;
    }
  }

  public static AccountBuilder anAccount() {
    return new AccountBuilder();
  }

  /*------------------------------------------------------------------------
	            AccountBuilderEnd
	------------------------------------------------------------------------*/

  /*------------------------------------------------------------------------
	             OpportunityBuilderStart
	------------------------------------------------------------------------*/
  public class OpportunityBuilder {
    private Opportunity obj = new Opportunity(
      Name = 'New Opp',
      StageName = '1 - Assignment',
      CloseDate = Date.today(),
      Customer__c = 'Test',
      Pillar__c = 'Cloud',
      Primary_Engineer__c = 'Wil Herrera',
      Forecast_Probability__c = 'Likely',
      Contract_Length_Months__c = '12',
      Is_Net_New_CSP_customer__c = 'Yes',
      Is_Renewel__c = 'Yes'
    );

    public OpportunityBuilder withAccountId(Id value) {
      obj.AccountId = value;
      return this;
    }
    public OpportunityBuilder withRecordTypeId(RecordType value) {
      obj.RecordTypeId = value.Id;
      return this;
    }

    public OpportunityBuilder withStageName(String value) {
      obj.StageName = value;
      return this;
    }

    public OpportunityBuilder withCloseDate(Date value) {
      obj.CloseDate = value;
      return this;
    }

    public Opportunity build() {
      return obj;
    }
  }

  public static OpportunityBuilder anOpportunity() {
    return new OpportunityBuilder();
  }

  public static OpportunityBuilder anOpportunityCSP() {
    OpportunityBuilder val = new OpportunityBuilder();
    val.obj.RecordTypeId = getRecordType('Opportunity', 'CSP_Opportunity').Id;
    return val;
  }

  public static OpportunityBuilder anOpportunityRT() {
    OpportunityBuilder val = new OpportunityBuilder();
    val.obj.RecordTypeId = getRecordType('Opportunity', 'Opportunity').Id;
    return val;
  }

  public static OpportunityBuilder anOpportunityEventRegistration() {
    OpportunityBuilder val = new OpportunityBuilder();
    val.obj.RecordTypeId = getRecordType('Opportunity', 'Event_Registration')
      .Id;
    return val;
  }

  /*------------------------------------------------------------------------
	             OpportunityBuilderEnd
	------------------------------------------------------------------------*/
  /*------------------------------------------------------------------------
	            UserBuilderStart
	------------------------------------------------------------------------*/

  public class UserBuilder {
    Profile prof = [
      SELECT Id
      FROM Profile
      WHERE PermissionsCustomizeApplication = TRUE
      ORDER BY CreatedDate ASC
      LIMIT 1
    ];
    private User obj = new User(
      Username = DateTime.now().getTime() +
        UserInfo.getOrganizationId() +
        'test@test.com.ItOne',
      LastName = 'STRING',
      Email = 'test@test.com',
      Alias = 'STRING',
      CommunityNickname = 'STRING' +
        DateTime.now().getTime() +
        UserInfo.getOrganizationId(),
      TimeZoneSidKey = 'America/Los_Angeles',
      LocaleSidKey = 'en_US',
      EmailEncodingKey = 'UTF-8',
      CurrencyIsoCode = 'USD',
      LanguageLocaleKey = 'en_US',
      DigestFrequency = 'D',
      DefaultGroupNotificationFrequency = 'N',
      profileId = prof.Id
    );

    public UserBuilder withProfileId(Profile value) {
      obj.ProfileId = value.Id;
      return this;
    }
    public UserBuilder withUsername(String value) {
      obj.Username = value;
      return this;
    }
    public UserBuilder withCommunityNickname(String value) {
      obj.CommunityNickname = value;
      return this;
    }
    public UserBuilder withCountry(String value) {
      obj.Country = value;
      return this;
    }
    public UserBuilder withAllArData(Boolean value) {
      obj.All_Ar_Data__c = value;
      return this;
    }
    public UserBuilder withRole(Id value) {
      obj.userRoleId = value;
      return this;
    }

    public User build() {
      return obj;
    }
  }

  /** It require following fields to can be inserted: ProfileId. */
  public static UserBuilder anUser() {
    return new UserBuilder();
  }

  public static User anUserCorporateSalesDiscoverOrg() {
    Profile profileId = [
      SELECT Id
      FROM Profile
      WHERE PermissionsCustomizeApplication = TRUE
      ORDER BY CreatedDate ASC
      LIMIT 1
    ];
    String userName = DateTime.now().getTime() + UserInfo.getOrganizationId();
    User anUser = anUser()
      .withProfileId(profileId)
      .withUsername(userName + 'adminccguser@test.test')
      .withCommunityNickname(userName)
      .withCountry('United States')
      .withAllArData(false)
      .build();
    System.runAs(new User(Id = UserInfo.getUserId())) {
      insert anUser;
    }

    String[] permissionSetLicensesNames = new List<String>{
      'X00DC00000016o78_gp1'
    };
    PermissionSetLicenseAssign[] pslsToInsert = new List<PermissionSetLicenseAssign>();
    PermissionSetLicense[] psls = [
      SELECT Id
      FROM PermissionSetLicense
      WHERE DeveloperName IN :permissionSetLicensesNames
    ];

    for (PermissionSetLicense psl : psls) {
      pslsToInsert.add(
        new PermissionSetLicenseAssign(
          AssigneeId = anUser.Id,
          PermissionSetLicenseId = psl.Id
        )
      );
    }
    System.runAs(new User(Id = UserInfo.getUserId())) {
      insert pslsToInsert;
    }

    PermissionSetGroup psAdmin = [
      SELECT Id
      FROM PermissionSetGroup
      WHERE DeveloperName = 'iT1_Corporate_Sales'
    ];
    System.runAs(new User(Id = UserInfo.getUserId())) {
      insert new PermissionSetAssignment(
        AssigneeId = anUser.Id,
        PermissionSetGroupId = psAdmin.Id
      );
    }

    return anUser;
  }
  /*------------------------------------------------------------------------
	             UserBuilderEnd
	------------------------------------------------------------------------*/
  /*------------------------------------------------------------------------
	            CommissionBuilderStart
	------------------------------------------------------------------------*/

  public class CommissionBuilder {
    private Commission__c obj = new Commission__c(
      Commision__c = 1000,
      Paid__c = true,
      Is_Cut_Commission__c = true,
      Is_Roll_Forward__c = false,
      Paid_Date__c = Date.today()
    );
    public CommissionBuilder withArData(Id value) {
      obj.Ar_Data__c = value;
      return this;
    }
    public CommissionBuilder withOwner(Id value) {
      obj.OwnerId = value;
      return this;
    }
    public CommissionBuilder withCommission(Integer value) {
      obj.Commision__c = value;
      return this;
    }
    public CommissionBuilder withPaid(Boolean value) {
      obj.Paid__c = value;
      return this;
    }
    public CommissionBuilder withIsCutCommission(Boolean value) {
      obj.Is_Cut_Commission__c = value;
      return this;
    }
    public CommissionBuilder withIsRollForward(Boolean value) {
      obj.Is_Roll_Forward__c = value;
      return this;
    }
    public CommissionBuilder withPaidDate(Date value) {
      obj.Paid_Date__c = value;
      return this;
    }

    public Commission__c build() {
      return obj;
    }
  }

  public static CommissionBuilder aCommission() {
    return new CommissionBuilder();
  }

  /*------------------------------------------------------------------------
	             CommissionBuilderEnd
	------------------------------------------------------------------------*/

  /*------------------------------------------------------------------------
	            RoleBuilderStart
	------------------------------------------------------------------------*/

  public class RoleBuilder {
    private UserRole obj = new UserRole(
      DeveloperName = 'UserRole',
      Name = 'UserRole'
    );
    public RoleBuilder withDeveloperName(String value) {
      obj.DeveloperName = value;
      return this;
    }
    public RoleBuilder withName(String value) {
      obj.Name = value;
      return this;
    }

    public UserRole build() {
      return obj;
    }
  }

  public static RoleBuilder aRole() {
    return new RoleBuilder();
  }
  /*------------------------------------------------------------------------
	             RoleBuilderEnd
	------------------------------------------------------------------------*/
  /*------------------------------------------------------------------------
	            ArDataBuilderStart
	------------------------------------------------------------------------*/

  public class ArDataBuilder {
    private Ar_Data__c obj = new Ar_Data__c(
      Invoice_Balance__c = 0,
      Original_Invoice__c = 0,
      Commissionable__c = 'Yes',
      Comp_Plan__c = 'Source',
      Invoice_Date__c = Date.today()
    );
    public ArDataBuilder withAccount(Id value) {
      obj.Account__c = value;
      return this;
    }
    public ArDataBuilder withSalesInvoice(Id value) {
      obj.Sales_Invoice__c = value;
      return this;
    }
    public ArDataBuilder withInvoiceBalance(Double value) {
      obj.Invoice_Balance__c = value;
      return this;
    }
    public ArDataBuilder withOriginalInvoice(Double value) {
      obj.Original_Invoice__c = value;
      return this;
    }
    public ArDataBuilder withCommissionable(String value) {
      obj.Commissionable__c = value;
      return this;
    }
    public ArDataBuilder withCompPlan(String value) {
      obj.Comp_Plan__c = value;
      return this;
    }
    public ArDataBuilder withSubTotal(Decimal value) {
      obj.Sub_Total__c = value;
      return this;
    }

    public Ar_Data__c build() {
      return obj;
    }
  }

  public static ArDataBuilder anArData() {
    return new ArDataBuilder();
  }
  /*------------------------------------------------------------------------
	             ArDataBuilderEnd
	------------------------------------------------------------------------*/
  /**

  /*------------------------------------------------------------------------
	            PurchasingTransactionBuilderStart
	------------------------------------------------------------------------*/

  public class PurchasingTransactionBuilder {
    private Purchasing_Transaction__c obj = new Purchasing_Transaction__c(
      Document_Number__c = '111',
      Vendor__c = '111',
      Record_Number__c = '111',
      Vendor_Document_Number__c = '111',
      Vendor_Type__c = '111',
      Vendor_Date__c = Date.parse('02/03/2021'),
      Sync_Line_Item__c = true,
      Sync_Sub_Total__c = true
    );
    public PurchasingTransactionBuilder withDocumentNumber(String value) {
      obj.Document_Number__c = value;
      return this;
    }

    public Purchasing_Transaction__c build() {
      return obj;
    }
  }

  public static PurchasingTransactionBuilder aPurchasingTransaction() {
    return new PurchasingTransactionBuilder();
  }
  /*------------------------------------------------------------------------
					 PurchasingTransactionBuilderEnd
		------------------------------------------------------------------------*/

  /*------------------------------------------------------------------------
	            FreightBuilderStart
	------------------------------------------------------------------------*/

  public class FreightBuilder {
    private freight__c obj = new freight__c(Cost__c = 34.3, Revenue__c = 23.4);
    public FreightBuilder withArData(Id value) {
      obj.AR_Data__c = value;
      return this;
    }
    public FreightBuilder withSalesInvoice(Id value) {
      obj.Sales_Invoice__c = value;
      return this;
    }
    public FreightBuilder withSalesOrder(Id value) {
      obj.Sales_Order__c = value;
      return this;
    }

    public freight__c build() {
      return obj;
    }
  }

  public static FreightBuilder aFreight() {
    return new FreightBuilder();
  }
  /*------------------------------------------------------------------------
						 FreightBuilderEnd
	------------------------------------------------------------------------*/

  /*------------------------------------------------------------------------
	            SalesOrderBuilderStart
	------------------------------------------------------------------------*/

  public class SalesOrderBuilder {
    private ia_crm__Sales_Order__c obj = new ia_crm__Sales_Order__c(
      ia_crm__Document_Number__c = '1374837263'
    );
    public SalesOrderBuilder withDocumentNumber(String value) {
      obj.ia_crm__Document_Number__c = value;
      return this;
    }
    public SalesOrderBuilder withAccount(Id value) {
      obj.ia_crm__Account__c = value;
      return this;
    }

    public ia_crm__Sales_Order__c build() {
      return obj;
    }
  }

  public static SalesOrderBuilder aSalesOrder() {
    return new SalesOrderBuilder();
  }
  /*------------------------------------------------------------------------
							 SalesOrderBuilderEnd
	------------------------------------------------------------------------*/

  /*------------------------------------------------------------------------
	            SalesInvoiceBuilderStart
	------------------------------------------------------------------------*/

  public class SalesInvoiceBuilder {
    private ia_crm__Sales_Invoice__c obj = new ia_crm__Sales_Invoice__c(
      Commissionable__c = 'No',
      ia_crm__Amount_Due__c = 100,
      ia_crm__Date__c = Date.today(),
      ia_crm__Invoice_Amount__c = 100,
      ia_crm__Subtotal__c = 200,
      ia_crm__Terms__c = 'Net 30',
      Ap_Freight_Cost__c = 50
    );

    public SalesInvoiceBuilder withAccount(Id value) {
      obj.ia_crm__Account__c = value;
      return this;
    }
    public SalesInvoiceBuilder withSalesOrder(Id value) {
      obj.Sales_Order__c = value;
      return this;
    }

    public ia_crm__Sales_Invoice__c build() {
      return obj;
    }
  }

  public static SalesInvoiceBuilder aSalesInvoice() {
    return new SalesInvoiceBuilder();
  }
  /*------------------------------------------------------------------------
								 SalesInvoiceBuilderEnd
		------------------------------------------------------------------------*/

  static Map<String, Map<String, RecordTypeInfo>> mapRecordTypesBySObjectName = new Map<String, Map<String, RecordTypeInfo>>();

  public static RecordType getRecordType(
    String sObjectTypeStr,
    String recordTypeName
  ) {
    if (
      mapRecordTypesBySObjectName.containsKey(sObjectTypeStr) &&
      mapRecordTypesBySObjectName.get(sObjectTypeStr)
        .containsKey(recordTypeName)
    ) {
      RecordTypeInfo rtInfo = mapRecordTypesBySObjectName.get(sObjectTypeStr)
        .get(recordTypeName);
      return new RecordType(
        Id = rtInfo.getRecordTypeId(),
        DeveloperName = rtInfo.getDeveloperName()
      );
    }
    SObjectType sObjecytType = Schema.getGlobalDescribe().get(sObjectTypeStr);
    if (sObjecytType == null) {
      return null;
    }
    mapRecordTypesBySObjectName.put(
      sObjectTypeStr,
      sObjecytType.getDescribe().getRecordTypeInfosByDeveloperName()
    );
    RecordTypeInfo rtInfo = mapRecordTypesBySObjectName.get(sObjectTypeStr)
      .get(recordTypeName);
    return new RecordType(
      Id = rtInfo.getRecordTypeId(),
      DeveloperName = rtInfo.getDeveloperName()
    );
  }
}
