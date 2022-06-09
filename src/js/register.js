App = {
    web3Provider: null,
    contracts: {},
    account: '0x0',
  
    init: async function() {
      return await App.initWeb3();
    },
  
    initWeb3: async function() {
      if (window.ethereum) {
        App.web3Provider = window.ethereum;
        try {
          await window.ethereum.enable();
        } catch (error) {
          console.error("User denied account access")
        }
      }
      else if (window.web3) {
        App.web3Provider = window.web3.currentProvider;
      }
      else {
        App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      }
      web3 = new Web3(App.web3Provider);
  
      return App.initContract();
    },
  
    initContract: function() {
      $.getJSON("TenderChain.json", function(data) {
        var TenderChainArtifact = data;
        App.contracts.TenderChain = TruffleContract(TenderChainArtifact);
        App.contracts.TenderChain.setProvider(App.web3Provider);
      });
  
      return App.setAccount();
    },
  
    setAccount: function() {
      web3.eth.getAccounts(function(error, accounts) {
        if (error) {
          console.log(error);
        } else {
          App.account = accounts[0];
          $('#accountAddress').attr('title',App.account);
        }
      });
    },
    uniqueid: function(){
      // always start with a letter (for DOM friendlyness)
      var idstr=String.fromCharCode(Math.floor((Math.random()*25)+65));
      do {                
          // between numbers and characters (48 is 0 and 90 is Z (42-48 = 90)
          var ascicode=Math.floor((Math.random()*42)+48);
          if (ascicode<58 || ascicode>64){
              // exclude all chars between : (58) and @ (64)
              idstr+=String.fromCharCode(ascicode);    
          }                
      } while (idstr.length<32);
  
      return (idstr);
  },
  
    registerUser: function() {
  
      $("#loadingOverlay").show();
      var accountName = $("#accountName").val();
      var accountEmail = $('#accountEmail').val();
      var phoneNumber = $('#phoneNumber').val();
      var accountUsername = $("#yourUsername").val();
     var accountType= $("#accountType").val();
  
      App.contracts.TenderChain.deployed().then(function(instance) {
        tenderchainUserInstance = instance;
        if (accountType == "Contractor") {
          return tenderchainUserInstance.createContractor(
            accountName,
            uniqueid(),
            accountEmail,
            phoneNumber,
            accountUsername,
            {from: App.account}
          );
        } else {
          return tenderchainUserInstance.createBidder(
            accountName,
            uniqueid(),
            accountEmail,
            phoneNumber,
            accountUsername,
            {from: App.account}
          );
          }
      }).then(function(result) {
        var manufacturerAddedEvent = supplychainManagerInstance.ManufacturerAdded();
        manufacturerAddedEvent.watch(function(error, result){
          if (!error) {
            $("#loadingOverlay").hide();
            showSuccessSnackbar();
            console.log("Added: "+result.args.manufacturerName+" "+result.args.manufacturerEthAddress);
          }
        });
      }).catch(function(err){
        $("#loadingOverlay").hide();
        showErrorSnackbar();
        console.log(err);
      });
    },
  
    // retrieveManufacturerByAddress: function() {
    //   var manufacturerAddress = $('#getManufacturerAddress').val();
  
    //   App.contracts.Supplychain.deployed().then(function(instance) {
    //     return instance.getManufacturerByAddress(manufacturerAddress);
    //   }).then(function(result) {
    //     $("#searchResult").html("Manufacturer: " + result);
    //     console.log(result);
    //   }).catch(function(err) {
    //     alert('Error in Get!');
    //   });
    // }
  
  };
  
  $(function() {
    $(window).on('load', function() {
      App.init();
    })}) 