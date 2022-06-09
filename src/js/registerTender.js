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
  
    registerTender: function() {
  
      $("#loadingOverlay").show();
  
     var tenderName = $('#tenderName').val();
     var tenderDescription = $('#tenderDescription').val();
     var bidOpeningDate = $('#bidOpeningDate').val();
     var bidClosingDate = $('#bidClosingDate').val();

  
      App.contracts.TenderChain.deployed().then(function(instance) {
        tenderchainInstance = instance;
        
        return tenderchainInstance.createTender(tenderName, tenderDescription, bidOpeningDate, bidClosingDate, {from: App.account});
  
      }).then(function(result) {
          console.log("Done!")
        var tenderProducedEvent = tenderchainInstance.tenderProduced();
        tenderProducedEvent.watch(function(error, result){
          if (!error) {
            $("#loadingOverlay").hide();
            showSuccessSnackbar();
            console.log("Created: "+result.args.tenderId+" "+result.args.companyId);
            // console.log("Random Number:"+result.args.randomNumber.c[0]);
  
// /$("#loadingOverlayInner").html("<strong>Product Registered</strong><p style=\"color: #cecece; font-weight: 200; font-size: 0.85em\" id=\"loader-description\">Copy th following details to the NFC Tag</p><p>EPC:&nbsp"+result.args.epc+"<br/>Secret:&nbsp"+result.args.randomNumber+"</p>");
            $('#loadingOverlayInner').css('background-color','#4F8A10')
            $("#loadingOverlay").show();
          }
        });
      }).catch(function(err){
        $("#loadingOverlay").hide();
        showErrorSnackbar();
        console.log(err);
      });
    }
  };
  
  $(function() {
    $(window).on('load', function() {
      App.init();
    });
  });
  