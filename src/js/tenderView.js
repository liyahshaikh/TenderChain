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
  
    tenderView: function() {
  
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
  
    
  };
  
  $(function() {
    $(window).on('load', function() {
      App.init();
      App.tenderView();
    })}) 