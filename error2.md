This document describes how to integrate the Google Play Billing Library into your app to start selling products.

Life of a purchase
Here's a typical purchase flow for a one-time purchase or a subscription.

Show the user what they can buy.
Launch the purchase flow for the user to accept the purchase.
Verify the purchase on your server.
Give content to the user.
Acknowledge delivery of the content. For consumable products, consume the purchase so that the user can buy the item again.
Subscriptions automatically renew until they are canceled. A subscription can go through the following states:

Active: User is in good standing and has access to the subscription.
Cancelled: User has cancelled but still has access until expiration.
In grace period: User experienced a payment issue but still has access while Google is retrying the payment method.
On hold: User experienced a payment issue and no longer has access while Google is retrying the payment method.
Paused: User paused their access and does not have access until they resume.
Expired: User has cancelled and lost access to the subscription. The user is considered churned at expiration.
Initialize a connection to Google Play
The first step to integrate with Google Play's billing system is to add the Google Play Billing Library to your app and initialize a connection.

Add the Google Play Billing Library dependency
Note: If you've followed the Getting ready guide, then you've already added the necessary dependencies and can move on to the next section.
Add the Google Play Billing Library dependency to your app's build.gradle file as shown:

Groovy
Kotlin

dependencies {
    def billing_version = "8.0.0"

    implementation "com.android.billingclient:billing:$billing_version"
}
If you're using Kotlin, the Google Play Billing Library KTX module contains Kotlin extensions and coroutines support that enable you to write idiomatic Kotlin when using the Google Play Billing Library. To include these extensions in your project, add the following dependency to your app's build.gradle file as shown:

Groovy
Kotlin

dependencies {
    def billing_version = "8.0.0"

    implementation "com.android.billingclient:billing-ktx:$billing_version"
}
Initialize a BillingClient
Once you've added a dependency on the Google Play Billing Library, you need to initialize a BillingClient instance. BillingClient is the main interface for communication between the Google Play Billing Library and the rest of your app. BillingClient provides convenience methods, both synchronous and asynchronous, for many common billing operations. Make note of the following:

It's recommended that you have one active BillingClient connection open at one time to avoid multiple PurchasesUpdatedListener callbacks for a single event.
It's recommended to initiate a connection for the BillingClient when your app is launched or comes to the foreground to ensure your app processes purchases in a timely manner. This can be accomplished by using ActivityLifecycleCallbacks registered by registerActivityLifecycleCallbacks and listening for onActivityResumed to initialize a connection when you first detect an activity being resumed. Refer to the section on processing purchases for more details on why this best practice should be followed. Also remember to end the connection when your app is closed.
To create a BillingClient, use newBuilder. You can pass any context to newBuilder(), and BillingClient uses it to get an application context. That means you don't need to worry about memory leaks. To receive updates on purchases, you must also call setListener, passing a reference to a PurchasesUpdatedListener. This listener receives updates for all purchases in your app.

Kotlin
Java

private val purchasesUpdatedListener =
   PurchasesUpdatedListener { billingResult, purchases ->
       // To be implemented in a later section.
   }

private var billingClient = BillingClient.newBuilder(context)
   .setListener(purchasesUpdatedListener)
   // Configure other settings.
   .build()
Note: The Google Play Billing Library returns errors in the form of BillingResult. A BillingResult contains a BillingResponseCode, which categorizes possible billing-related errors that your app can encounter. For example, if you receive a SERVICE_DISCONNECTED error code, your app should reinitialize the connection with Google Play. Additionally, a BillingResult contains a debug message, which is useful during development to diagnose errors.
Connect to Google Play
After you have created a BillingClient, you need to establish a connection to Google Play.

To connect to Google Play, call startConnection. The connection process is asynchronous, and you must implement a BillingClientStateListener to receive a callback once the setup of the client is complete and it's ready to make further requests.

You must also implement retry logic to handle lost connections to Google Play. To implement retry logic, override the onBillingServiceDisconnected() callback method, and make sure that the BillingClient calls the startConnection() method to reconnect to Google Play before making further requests.

The following example demonstrates how to start a connection and test that it's ready to use:

Kotlin
Java

billingClient.startConnection(object : BillingClientStateListener {
    override fun onBillingSetupFinished(billingResult: BillingResult) {
        if (billingResult.responseCode ==  BillingResponseCode.OK) {
            // The BillingClient is ready. You can query purchases here.
        }
    }
    override fun onBillingServiceDisconnected() {
        // Try to restart the connection on the next request to
        // Google Play by calling the startConnection() method.
    }
})
Note: It's strongly recommended that you use the automatic service reconnection feature, as described in the following section. If you choose not to use this feature, it's strongly recommended that you implement your own connection retry logic and override the onBillingServiceDisconnected() method. In either case, make sure you maintain the BillingClient connection when executing any methods.
Automatically Re-establish a Connection
With the introduction of the enableAutoServiceReconnection() method in BillingClient.Builder in version 8.0.0, the Play Billing Library can now automatically re-establish the service connection if an API call is made while the service is disconnected. This can lead to a reduction in SERVICE_DISCONNECTED responses since the reconnection is handled internally before the API call is made.

How to enable automatic reconnection
When building a BillingClient instance, use the enableAutoServiceReconnection() method in the BillingClient.Builder to enable automatic reconnection.

Kotlin
Java

val billingClient = BillingClient.newBuilder(context)
    .setListener(listener)
    .enablePendingPurchases()
    .enableAutoServiceReconnection() // Add this line to enable reconnection
    .build()
Show products available to buy
After you have established a connection to Google Play, you are ready to query for your available products and display them to your users.

Querying for product details is an important step before displaying your products to your users, as it returns localized product information. For subscriptions, verify your product display follows all Play policies.

To query for one-time product details, call the queryProductDetailsAsync method. This method can return multiple offers based on your one-time product configuration. For more information, see Multiple purchase options and offers for one-time products.

To handle the result of the asynchronous operation, you must also specify a listener which implements the ProductDetailsResponseListener interface. You can then override onProductDetailsResponse, which notifies the listener when the query finishes, as shown in the following example:

Kotlin
Java

val queryProductDetailsParams =
    QueryProductDetailsParams.newBuilder()
        .setProductList(
            ImmutableList.of(
                Product.newBuilder()
                    .setProductId("product_id_example")
                    .setProductType(ProductType.SUBS)
                    .build()))
        .build()

billingClient.queryProductDetailsAsync(queryProductDetailsParams) {
    billingResult,
    queryProductDetailsResult ->
      if (billingResult.getResponseCode() == BillingResponseCode.OK) {
               for (ProductDetails productDetails : queryProductDetailsResult.getProductDetailsList()) {
                 // Process successfully retrieved product details here.
               }

               for (UnfetchedProduct unfetchedProduct : queryproductDetailsResult.getUnfetchedProductList()) {
                 // Handle any unfetched products as appropriate.
               }
            }
}
When querying for product details, pass an instance of QueryProductDetailsParams that specifies a list of product ID strings created in Google Play Console along with a ProductType. The ProductType can be either ProductType.INAPP for one-time products or ProductType.SUBS for subscriptions.

Query with Kotlin extensions
If you're using Kotlin extensions, you can query for one-time product details by calling the queryProductDetails() extension function.

queryProductDetails() leverages Kotlin coroutines so that you don't need to define a separate listener. Instead, the function suspends until the querying completes, after which you can process the result:


suspend fun processPurchases() {
    val productList = listOf(
        QueryProductDetailsParams.Product.newBuilder()
            .setProductId("product_id_example")
            .setProductType(BillingClient.ProductType.SUBS)
            .build()
    )
    val params = QueryProductDetailsParams.newBuilder()
    params.setProductList(productList)

    // leverage queryProductDetails Kotlin extension function
    val productDetailsResult = withContext(Dispatchers.IO) {
        billingClient.queryProductDetails(params.build())
    }

    // Process the result.
}
Rarely, some devices are unable to support ProductDetails and queryProductDetailsAsync(), usually due to outdated versions of Google Play Services. To provide proper support for this scenario, learn how to use backwards compatibility features in the Play Billing Library 7 migration guide.

Process the result
The Google Play Billing Library stores the query results in a QueryProductDetailsResult object. QueryProductDetailsResult contains a List of ProductDetails objects. You can then call a variety of methods on each ProductDetails object in the list to view relevant information about a successfully fetched one-time product, such as its price or description. To view the available product detail information, see the list of methods in the ProductDetails class.

QueryProductDetailsResult also contains a List of UnfetchedProduct objects. You can then query each UnfetchedProduct to get a status code corresponding to the fetch failure reason. To view the available unfetched product information, see the list of methods in the UnfetchedProduct class.

Before offering an item for sale, check that the user does not already own the item. If the user has a consumable that is still in their item library, they must consume the item before they can buy it again.

Before offering a subscription, verify that the user is not already subscribed. Also note the following:

For subscriptions, the queryProductDetailsAsync() method returns subscription product details and a maximum of 50 user eligible offers per subscription. If the user attempts to purchase an ineligible offer (for example, if the app is displaying an outdated list of eligible offers), Play informs the user that they are ineligible, and the user can choose to purchase the base plan instead.

For one-time products, the queryProductDetailsAsync() method returns only the user eligible offers. If the user attempts to purchase an offer for which they're ineligible (for example, if the user has reached the purchase quantity limit), Play informs the user that they are ineligible, and the user can choose to purchase its purchase option offer instead.

Note: Caching ProductDetails objects is not recommended, as stale objects can cause launchBillingFlow() failures.
Note: Some Android devices might have an older version of the Google Play Store app that doesn't support certain products types, such as subscriptions. Before your app enters the billing flow, you can call isFeatureSupported() to determine whether the device supports the products you want to sell. For a list of product types that can be supported, see BillingClient.FeatureType.
Launch the purchase flow
To start a purchase request from your app, call the launchBillingFlow() method from your app's main thread. This method takes a reference to a BillingFlowParams object that contains the relevant ProductDetails object obtained from calling queryProductDetailsAsync. To create a BillingFlowParams object, use the BillingFlowParams.Builder class.


Kotlin
Java

// An activity reference from which the billing flow will be launched.
val activity : Activity = ...;

val productDetailsParamsList = listOf(
    BillingFlowParams.ProductDetailsParams.newBuilder()
        // retrieve a value for "productDetails" by calling queryProductDetailsAsync()
        .setProductDetails(productDetails)
        // Get the offer token:
        // a. For one-time products, call ProductDetails.getOneTimePurchaseOfferDetailsList()
        // for a list of offers that are available to the user.
        // b. For subscriptions, call ProductDetails.subscriptionOfferDetails()
        // for a list of offers that are available to the user.
        .setOfferToken(selectedOfferToken)
        .build()
)

val billingFlowParams = BillingFlowParams.newBuilder()
    .setProductDetailsParamsList(productDetailsParamsList)
    .build()

// Launch the billing flow
val billingResult = billingClient.launchBillingFlow(activity, billingFlowParams)
The launchBillingFlow() method returns one of several response codes listed in BillingClient.BillingResponseCode. Be sure to check this result to verify there were no errors launching the purchase flow. A BillingResponseCode of OK indicates a successful launch.

On a successful call to launchBillingFlow(), the system displays the Google Play purchase screen. Figure 1 shows a purchase screen for a subscription:

the google play purchase screen shows a subscription that is
            available for purchase
Figure 1. The Google Play purchase screen shows a subscription that is available for purchase.
Google Play calls onPurchasesUpdated() to deliver the result of the purchase operation to a listener that implements the PurchasesUpdatedListener interface. The listener is specified using the setListener() method when you initialized your client.

You must implement onPurchasesUpdated() to handle possible response codes. The following example shows how to override onPurchasesUpdated():

Kotlin
Java

override fun onPurchasesUpdated(billingResult: BillingResult, purchases: List<Purchase>?) {
   if (billingResult.responseCode == BillingResponseCode.OK && purchases != null) {
       for (purchase in purchases) {
           // Process the purchase as described in the next section.
       }
   } else if (billingResult.responseCode == BillingResponseCode.USER_CANCELED) {
       // Handle an error caused by a user canceling the purchase flow.
   } else {
       // Handle any other error codes.
   }
}
A successful purchase generates a Google Play purchase success screen similar to figure 2.

google play's purchase success screen
Figure 2. Google Play's purchase success screen.
A successful purchase also generates a purchase token, which is a unique identifier that represents the user and the product ID for the one-time product they purchased. Your apps can store the purchase token locally, though we strongly recommend passing the token to your secure backend server where you can then verify the purchase and protect against fraud. This process is further described in Detecting and Processing Purchases.

The user is also emailed a receipt of the transaction containing an Order ID or a unique ID of the transaction. Users receive an email with a unique Order ID for each one-time product purchase, and also for the initial subscription purchase and subsequent recurring automatic renewals. You can use the Order ID to manage refunds in the Google Play Console.

Indicate a personalized price
If your app can be distributed to users in the European Union, use the setIsOfferPersonalized() method when calling launchBillingFlow to disclose to users that an item's price was personalized using automated decision-making.

The Google Play purchase screen indicating that the price was customized for the user.
Figure 3. The Google Play purchase screen indicating that the price was customized for the user.
You must consult Art. 6 (1) (ea) CRD of the Consumer Rights Directive 2011/83/EU to determine if the price you are offering to users is personalized.

setIsOfferPersonalized() takes a boolean input. When true, the Play UI includes the disclosure. When false, the UI omits the disclosure. The default value is false.

See the Consumer Help Center for more information.

Attach user identifiers
When you launch the purchase flow your app can attach any user identifiers you have for the user making the purchase using obfuscatedAccountId or obfuscatedProfileId. An example identifier could be an obfuscated version of the user's login in your system. Setting these parameters can help Google detect fraud. Additionally, it can help you ensure that purchases are attributed to the right user as discussed in granting entitlements to users.

Detect and process purchases
The detection and processing of a purchase described in this section is applicable to all types of purchases including out of app purchases like promotion redemptions.

Your app detect new purchases and completed pending purchases in one of the following ways:

When onPurchasesUpdated is called as a result of your app calling launchBillingFlow (as discussed in the previous section) or if your app is running with an active Billing Library connection when there is a purchase made outside your app or a pending purchase is completed. For example, a family member approves a pending purchase on another device.
When your app calls queryPurchasesAsync to query the user's purchases.
For #1 onPurchasesUpdated will automatically be called for new or completed purchases as long as your app is running and has an active Google Play Billing Library connection. If your application is not running or your app doesn't have an active Google Play Billing library connection, onPurchasesUpdated won't be invoked. Remember, it is recommended for your app to try to keep an active connection as long as your app is in the foreground so that your app gets timely purchase updates.

For #2 you must call BillingClient.queryPurchasesAsync() to ensure your app processes all purchases. It is recommended that you do this when your app successfully establishes a connection with the Google Play Billing Library (which is recommended when your app is launched or comes to the foreground as discussed in initialize a BillingClient. This can be accomplished by calling queryPurchasesAsync when receiving a successful result to onServiceConnected. Following this recommendation is critical to handle events and situations such as:

Network Issues during the purchase: A user can make a successful purchase and receive confirmation from Google, but their device loses network connectivity before their device and your app receives notification of the purchase through the PurchasesUpdatedListener.
Multiple devices: A user may buy an item on one device and then expect to see the item when they switch devices.
Handling purchases made outside your app: Some purchases, such as promotion redemptions, can be made outside your app.
Handling purchase state transitions: A user may complete payment for a PENDING purchase while your application is not running and expect to receive confirmation that they completed the purchase when they open your app.
Note: You can also choose to listen to Real-time Developer Notifications to learn about new purchases and completed pending purchases in real-time, even if the user is not using your app when the event occurs. This helps you keep your backend state in sync at all times. This is described in more detail in the backend integration section for one-time purchases and subscriptions.
Once your app detects a new or completed purchase then your app should:

Verify the purchase.
Grant content to the user for completed purchases.
Notify the user.
Notify Google that your app processed completed purchases.
These steps are discussed in detail in the following sections followed by a section to recap all the steps.

Verify the purchase
Your app should always verify the legitimacy of purchases before granting benefits to a user. This can be done by following the guidelines described in Verify purchases before granting entitlements. Only after verifying the purchase should your app continue to process the purchase and grant entitlements to the user, which is discussed in the next section.

Grant entitlement to the user
Once your app has verified a purchase it can continue to grant the entitlement to the user and notify the user. Before granting entitlement, verify that your app is checking that the purchase state is PURCHASED. If the purchase is in PENDING state, your app should notify the user that they still need to complete actions to complete the purchase before entitlement is granted. Only grant entitlement when the purchase transitions from PENDING to SUCCESS. Additional information can be found in Handling pending transactions.

If you have attached user identifiers to the purchase as discussed in attaching user identifiers you can retrieve and use them to attribute to the correct user in your system. This technique is useful when reconciling purchases where your app may have lost context about which user a purchase is for. Note, purchases made outside your app won't have these identifiers set. In this case your app can either grant the entitlement to the logged in user, or prompt the user to select a preferred account.

For pre-orders, the purchase is in PENDING state before the release time is reached. The preorder purchase will complete at the release time and change the state to PURCHASED without additional actions.

Notify the User
After granting entitlement to the user, your app should show a notification to acknowledge the successful purchase. Because of the notification, the user is not confused as to whether the purchase completed successfully, which could result in the user stopping using your app, contacting user support, or complaining about it on social media. Be aware that your app may detect purchase updates at any time during your application lifecycle. For example, a parent approves a pending purchase on another device, in which case your app may want to delay notifying the user to an appropriate time. Some examples where a delay would be appropriate are:

During the action part of a game or cutscenes, showing a message may distract the user. In this case, you must notify the user after the action part is over.
During the initial tutorial and user setup parts of the game. For example, a user may have made a purchase outside your app before installing it. We recommend you notify new users of the reward immediately after they open the game or during initial user setup. If your app requires the user to create an account or logging in before granting entitlement to the user it is recommended to communicate to your user which steps to complete to claim their purchase. This is critical since purchases are refunded after 3 days if your app has not processed the purchase.
When notifying the user about a purchase, Google Play recommends the following mechanisms:

Show an in-app dialog.
Deliver the message to an in-app message box, and clearly stating that there is a new message in the in-app message box.
Use an OS notification message.
The notification should notify the user about the benefit they received. For example, "You purchased 100 Gold Coins!". Additionally, if the purchase was a result of a benefit of a program such as Play Pass your app communicates this to the user. For example "Items received! You just got 100 Gems with Play Pass. Continue.". Each program may have guidance on the recommended text to display to users to communicate benefits.

Notify Google the purchase was processed
After your app has granted entitlement to the user and notified them about the successful transaction, your app needs to notify Google that the purchase was successfully processed. This is done by acknowledging the purchase and must be done within three days so that the purchase isn't automatically refunded and entitlement revoked. The process for acknowledging different types of purchases is described in the following sections.

Consumable products
For consumables, if your app has a secure backend, we recommend that you use Purchases.products:consume to reliably consume purchases. Make sure the purchase wasn't already consumed by checking the consumptionState from the result of calling Purchases.products:get. If your app is client-only without a backend, use consumeAsync() from the Google Play Billing Library. Both methods fulfill the acknowledgement requirement and indicate that your app has granted entitlement to the user. These methods also enable your app to make the one-time product corresponding to the input purchase token available for repurchase. With consumeAsync() you must also pass an object that implements the ConsumeResponseListener interface. This object handles the result of the consumption operation. You can override the onConsumeResponse() method, which the Google Play Billing Library calls when the operation is complete.

The following example illustrates consuming a product with the Google Play Billing Library using the associated purchase token:

Kotlin
Java

    val consumeParams =
        ConsumeParams.newBuilder()
            .setPurchaseToken(purchase.getPurchaseToken())
            .build()
    val consumeResult = withContext(Dispatchers.IO) {
        client.consumePurchase(consumeParams)
    }
Note: Purchases made using Play Points are auto-acknowledged, and you don't need to acknowledge such purchases using the acknowledge flow. As consumption requests can occasionally fail, you must check your secure backend server to verify that each purchase token hasn't been used so your app doesn't grant entitlement multiple times for the same purchase. Alternatively, your app can wait until you receive a successful consumption response from Google Play before granting entitlement. If you choose to withhold purchases from the user until Google Play sends a successful consumption response, you must be very careful not to lose track of the purchases for which you have sent a consumption request.
Non-consumable products
To acknowledge non-consumable purchases, if your app has a secure backend, we recommend using Purchases.products:acknowledge to reliably acknowledge purchases. Make sure the purchase hasn't been previously acknowledged by checking the acknowledgementState from the result of calling Purchases.products:get.

If your app is client-only, use BillingClient.acknowledgePurchase() from the Google Play Billing Library in your app. Before acknowledging a purchase, your app should check whether it was already acknowledged by using the isAcknowledged() method in the Google Play Billing Library.

The following example shows how to acknowledge a purchase using the Google Play Billing Library:

Kotlin
Java

val client: BillingClient = ...
val acknowledgePurchaseResponseListener: AcknowledgePurchaseResponseListener = ...

val acknowledgePurchaseParams = AcknowledgePurchaseParams.newBuilder()
    .setPurchaseToken(purchase.purchaseToken)
val ackPurchaseResult = withContext(Dispatchers.IO) {
     client.acknowledgePurchase(acknowledgePurchaseParams.build())
}
Subscriptions
Subscriptions are handled similarly to non-consumables. If possible, use Purchases.subscriptions.acknowledge from the Google Play Developer API to reliably acknowledge the purchase from your secure backend. Verify that the purchase hasn't been previously acknowledged by checking the acknowledgementState in the purchase resource from Purchases.subscriptions:get. Otherwise, you can acknowledge a subscription using BillingClient.acknowledgePurchase() from the Google Play Billing Library after checking isAcknowledged(). All initial subscription purchases need to be acknowledged. Subscription renewals don't need to be acknowledged. For more information about when subscriptions need to be acknowledged, see the Sell subscriptions topic.

Recap
The following code snippet shows a recap of these steps.

Kotlin
Java

fun handlePurchase(Purchase purchase) {
    // Purchase retrieved from BillingClient#queryPurchasesAsync or your
    // onPurchasesUpdated.
    Purchase purchase = ...;

    // Step 1: Send the purchase to your secure backend to verify the purchase
    // following
    // https://developer.android.com/google/play/billing/security#verify
.
    // Step 2: Update your entitlement storage with the purchase. If purchase is
    // in PENDING state then ensure the entitlement is marked as pending and the
    // user does not receive benefits yet. It is recommended that this step is
    // done on your secure backend and can combine in the API call to your
    // backend in step 1.

    // Step 3: Notify the user using appropriate messaging (delaying
    // notification if needed as discussed above).

    // Step 4: Notify Google the purchase was processed using the steps
    // discussed in the processing purchases section.
}
To verify your app has correctly implemented these steps you can follow the testing guide.

Handle pending transactions
Google Play supports pending transactions, or transactions that require one or more additional steps between when a user initiates a purchase and when the payment method for the purchase is processed. Your app shouldn't grant entitlement to these types of purchases until Google notifies you that the user's payment method was successfully charged.

For example, a user can initiate a transaction by choosing a physical store where they'll pay later with cash. The user receives a code through both notification and email. When the user arrives at the physical store, they can redeem the code with the cashier and pay with cash. Google then notifies both you and the user that payment has been received. Your app can then grant entitlement to the user.

Call enablePendingPurchases() as part of initializing the BillingClient to enable pending transactions for your app. Your app must enable and support pending transactions for one-time products. Before adding support, be sure you understand the purchase lifecycle for pending transactions.

Note: For apps using Google Play Billing Library version 7.0 and higher, you can enable pending transactions for subscription prepaid plan purchases. See Handle subscription pending transactions for how to support in your app.
When your app receives a new purchase, either through your PurchasesUpdatedListener or as a result of calling queryPurchasesAsync, use the getPurchaseState() method to determine whether the purchase state is PURCHASED or PENDING. You should grant entitlement only when the state is PURCHASED.

If your app is running and you have an active Play Billing Library connection when the user completes the purchase, your PurchasesUpdatedListener is called again, and the PurchaseState is now PURCHASED. At this point, your app can process the purchase using the standard method for Detecting and Processing Purchases. Your app should also call queryPurchasesAsync() in your app's onResume() method to handle purchases that have transitioned to the PURCHASED state while your app was not running.

Note: You should acknowledge a purchase only when the state is PURCHASED, i.e. Don't acknowledge it while a purchase is in PENDING state. The three day acknowledgement window begins only when the purchase state transitions from 'PENDING' to 'PURCHASED'.
When the purchase transitions from PENDING to PURCHASED, your real_time_developer_notifications client receives a ONE_TIME_PRODUCT_PURCHASED or SUBSCRIPTION_PURCHASED notification. If the purchase is cancelled, you will receive a ONE_TIME_PRODUCT_CANCELED or SUBSCRIPTION_PENDING_PURCHASE_CANCELED notification. This can happen if your customer does not complete payment in the required timeframe. Note that you can always use the Google Play Developer API to check the current state of a purchase.

Note: Pending transactions can be tested with application licensing. In addition to two test credit cards, license testers have access to two test instruments for delayed forms of payment where the payment automatically completes or cancels after a couple of minutes. You can find detailed steps on how to test this scenario at Test pending transactions.
Handle multi-quantity purchases
Supported in versions 4.0 and higher of the Google Play Billing Library, Google Play allows customers to purchase more than one of the same one-time product in one transaction by specifying a quantity from the purchase cart. Your app is expected to handle multi-quantity purchases and grant entitlement based on the specified purchase quantity.

Note: Multi-quantity is meant for consumable one-time products, products that can be purchased, consumed, and purchased again. Don't enable this feature for products that are not meant to be purchased repeatedly. And in the case of offers, multi-quantity purchases are only supported for purchase options (buy or rent) and not offers.
To honor multi-quantity purchases, your app's provisioning logic needs to check for an item quantity. You can access a quantity field from one of the following APIs:

getQuantity() from the Google Play Billing Library.
Purchases.products.quantity from the Google Play Developer API
After you've added logic to handle multi-quantity purchases, you then need to enable the multi-quantity feature for the corresponding product on the one-time product management page in the Google Play Developer Console.

Note: Be sure your app honors multi-quantity purchases before enabling the feature in the console. You might need to force an update to a version of your app that provides support before you can enable the feature on a product.
Query user's billing configuration
getBillingConfigAsync() provides the country the user uses for Google Play.

Note: Don't store any data that getBillingConfigAsync() returns; this data is designed to be used only once and can change at any time. You may not use getBillingConfigAsync() data to create or enhance a user profile or to target or track customers for advertising or marketing purposes.
You can query the user's billing configuration after creating a BillingClient. The following code snippet describes how to make a call to getBillingConfigAsync(). Handle the response by implementing the BillingConfigResponseListener. This listener receives updates for all billing config queries initiated from your app.

If the returned BillingResult contains no errors, you can then check the countryCode field in the BillingConfig object to obtain the user's Play Country.

Note: The country code format is based on ISO-3166-1 alpha2 (UN country codes). See the Territory Containment table for more details.
Kotlin
Java

// Use the default GetBillingConfigParams.
val getBillingConfigParams = GetBillingConfigParams.newBuilder().build()
billingClient.getBillingConfigAsync(getBillingConfigParams,
    object : BillingConfigResponseListener {
        override fun onBillingConfigResponse(
            billingResult: BillingResult,
            billingConfig: BillingConfig?
        ) {
            if (billingResult.responseCode == BillingResponseCode.OK
                && billingConfig != null) {
                val countryCode = billingConfig.countryCode
                ...
            } else {
                // TODO: Handle errors
            }
        }
    })
Cart abandonment reminders in Google Play Games home (enabled by default)
For Games developers that monetize through one-time products, one way in which stock-keeping units (SKUs) that are active in Google Play Console can be sold outside of your app is the Cart Abandonment Reminder feature, which nudges users to complete their previously abandoned purchases while browsing the Google Play Store. These purchases happen outside of your app, from the Google Play Games home in the Google Play Store.

This feature is enabled by default to help users pick up where they left off and to help developers maximize sales. However, you can opt your app out of this feature by submitting the Cart Abandonment Reminder feature opt-out form. For best practices on managing SKUs within the Google Play Console, see Create an in-app product.

The following images show the Cart Abandonment Reminder appearing on the Google Play Store:

the Google Play Store screen shows a
    purchase prompt for a previously abandoned purchase
Figure 2. The Google Play Store screen shows a purchase prompt for a previously abandoned purchase.
the Google Play Store screen shows a
    purchase prompt for a previously abandoned purchase
Figure 3. The Google Play Store screen shows a purchase prompt for a previously abandoned purchase.
Was this helpful?

