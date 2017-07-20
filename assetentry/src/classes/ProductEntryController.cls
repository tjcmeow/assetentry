public class ProductEntryController {
    public List<AssetWrapper> wrappers {get; set;}
    public static Integer toDelIdent {get; set;}
    public static Integer addCount {get; set;}
    private Integer nextIdent=0;
    
    public ProductEntryController() {
        wrappers=new List<AssetWrapper>();
        for (Integer idx=0; idx<1; idx++) {
            wrappers.add(new AssetWrapper(nextIdent++));
        }
    }
  
    public void delWrapper() {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrappers.size(); idx++) {
            if (wrappers[idx].ident==toDelIdent) {
                toDelPos=idx;
            }
        }
   
        if (-1!=toDelPos) {
            wrappers.remove(toDelPos);
        }
    }
    
    public void addRows() {
        for (Integer idx=0; idx<addCount; idx++) {
            wrappers.add(new AssetWrapper(nextIdent++));
        }
    }
  
    public PageReference save() {
        List<Asset> assts=new List<Asset>();
        Asset parentId = new Asset();
        parentId.Id =  ApexPages.currentPage().getParameters().get('parentId');
        system.debug(parentId.Id);
        Account acc = new Account();
        Product2 prod = new Product2();
        acc.Id = parentId.AccountId;       
        for (AssetWrapper wrap : wrappers) {
            wrap.asst.AccountId = acc.Id;
            String serial = wrap.asst.Name;
            prod.Id = wrap.asst.Product2Id;
            String partno = prod.ProductCode;
            String assid = partno + '_US_' + serial;
            wrap.asst.Asset_ID__c = assid;
            wrap.asst.Parent_Asset__c = parentId.Id;
            assts.add(wrap.asst);
        }
        insert assts;
        return new PageReference('/' + parentId.Id);
    }
  
    public class AssetWrapper {
        public Asset asst {get; private set;}
        public Integer ident {get; private set;}
   
        public AssetWrapper(Integer inIdent) {
            ident=inIdent;
            asst=new Asset(Name='Child Asset ' + ident);
        }
    }
}