Resource: OneTimeProduct
A single one-time product for an app.

JSON representation

{
  "packageName": string,
  "productId": string,
  "listings": [
    {
      object (OneTimeProductListing)
    }
  ],
  "taxAndComplianceSettings": {
    object (OneTimeProductTaxAndComplianceSettings)
  },
  "purchaseOptions": [
    {
      object (OneTimeProductPurchaseOption)
    }
  ],
  "restrictedPaymentCountries": {
    object (RestrictedPaymentCountries)
  },
  "offerTags": [
    {
      object (OfferTag)
    }
  ],
  "regionsVersion": {
    object (RegionsVersion)
  }
}
Fields
packageName	
string

Required. Immutable. Package name of the parent app.

productId	
string

Required. Immutable. Unique product ID of the product. Unique within the parent app. Product IDs must start with a number or lowercase letter, and can contain numbers (0-9), lowercase letters (a-z), underscores (_), and periods (.).

listings[]	
object (OneTimeProductListing)

Required. Set of localized title and description data. Must not have duplicate entries with the same languageCode.

taxAndComplianceSettings	
object (OneTimeProductTaxAndComplianceSettings)

Details about taxes and legal compliance.

purchaseOptions[]	
object (OneTimeProductPurchaseOption)

Required. The set of purchase options for this one-time product.

restrictedPaymentCountries	
object (RestrictedPaymentCountries)

Optional. Countries where the purchase of this one-time product is restricted to payment methods registered in the same country. If empty, no payment location restrictions are imposed.

offerTags[]	
object (OfferTag)

Optional. List of up to 20 custom tags specified for this one-time product, and returned to the app through the billing library. Purchase options and offers for this product will also receive these tags in the billing library.

regionsVersion	
object (RegionsVersion)

Output only. The version of the regions configuration that was used to generate the one-time product.

OneTimeProductListing
Regional store listing for a one-time product.

JSON representation

{
  "languageCode": string,
  "title": string,
  "description": string
}
Fields
languageCode	
string

Required. The language of this listing, as defined by BCP-47, e.g., "en-US".

title	
string

Required. The title of this product in the language of this listing. The maximum length is 55 characters.

description	
string

Required. The description of this product in the language of this listing. The maximum length is 200 characters.

OneTimeProductTaxAndComplianceSettings
Details about taxation, Google Play policy and legal compliance for one-time products.

JSON representation

{
  "regionalTaxConfigs": [
    {
      object (RegionalTaxConfig)
    }
  ],
  "isTokenizedDigitalAsset": boolean
}
Fields
regionalTaxConfigs[]	
object (RegionalTaxConfig)

Regional tax configuration.

isTokenizedDigitalAsset	
boolean

Whether this one-time product is declared as a product representing a tokenized digital asset.

RegionalTaxConfig
Details about taxation in a given geographical region.

JSON representation

{
  "regionCode": string,
  "taxTier": enum (TaxTier),
  "eligibleForStreamingServiceTaxRate": boolean,
  "streamingTaxType": enum (StreamingTaxType)
}
Fields
regionCode	
string

Required. Region code this configuration applies to, as defined by ISO 3166-2, e.g. "US".

taxTier	
enum (TaxTier)

Tax tier to specify reduced tax rate. Developers who sell digital news, magazines, newspapers, books, or audiobooks in various regions may be eligible for reduced tax rates.

Learn more.

eligibleForStreamingServiceTaxRate	
boolean

You must tell us if your app contains streaming products to correctly charge US state and local sales tax. Field only supported in the United States.

streamingTaxType	
enum (StreamingTaxType)

To collect communications or amusement taxes in the United States, choose the appropriate tax category.

Learn more.

OneTimeProductPurchaseOption
A single purchase option for a one-time product.

JSON representation

{
  "purchaseOptionId": string,
  "state": enum (State),
  "regionalPricingAndAvailabilityConfigs": [
    {
      object (RegionalPricingAndAvailabilityConfig)
    }
  ],
  "newRegionsConfig": {
    object (OneTimeProductPurchaseOptionNewRegionsConfig)
  },
  "offerTags": [
    {
      object (OfferTag)
    }
  ],
  "taxAndComplianceSettings": {
    object (PurchaseOptionTaxAndComplianceSettings)
  },

  // Union field purchase_option_type can be only one of the following:
  "buyOption": {
    object (OneTimeProductBuyPurchaseOption)
  },
  "rentOption": {
    object (OneTimeProductRentPurchaseOption)
  }
  // End of list of possible types for union field purchase_option_type.
}
Fields
purchaseOptionId	
string

Required. Immutable. The unique identifier of this purchase option. Must be unique within the one-time product. It must start with a number or lower-case letter, and can only contain lower-case letters (a-z), numbers (0-9), and hyphens (-). The maximum length is 63 characters.

state	
enum (State)

Output only. The state of the purchase option, i.e., whether it's active. This field cannot be changed by updating the resource. Use the dedicated endpoints instead.

regionalPricingAndAvailabilityConfigs[]	
object (RegionalPricingAndAvailabilityConfig)

Regional pricing and availability information for this purchase option.

newRegionsConfig	
object (OneTimeProductPurchaseOptionNewRegionsConfig)

Pricing information for any new locations Play may launch in the future. If omitted, the purchase option will not be automatically available in any new locations Play may launch in the future.

offerTags[]	
object (OfferTag)

Optional. List of up to 20 custom tags specified for this purchase option, and returned to the app through the billing library. Offers for this purchase option will also receive these tags in the billing library.

taxAndComplianceSettings	
object (PurchaseOptionTaxAndComplianceSettings)

Optional. Details about taxes and legal compliance.

Union field purchase_option_type. The type of this purchase option. Exactly one must be set. purchase_option_type can be only one of the following:
buyOption	
object (OneTimeProductBuyPurchaseOption)

A purchase option that can be bought.

rentOption	
object (OneTimeProductRentPurchaseOption)

A purchase option that can be rented.

State
The current state of the purchase option.

Enums
STATE_UNSPECIFIED	Default value, should never be used.
DRAFT	The purchase option is not and has never been available to users.
ACTIVE	The purchase option is available to users.
INACTIVE	The purchase option is not available to users anymore.
INACTIVE_PUBLISHED	The purchase option is not available for purchase anymore, but we continue to expose its offer via the Play Billing Library for backwards compatibility. Only automatically migrated purchase options can be in this state.
OneTimeProductBuyPurchaseOption
A purchase option that can be bought.

JSON representation

{
  "legacyCompatible": boolean,
  "multiQuantityEnabled": boolean
}
Fields
legacyCompatible	
boolean

Optional. Whether this purchase option will be available in legacy PBL flows that do not support one-time products model.

Up to one "buy" purchase option can be marked as backwards compatible.

multiQuantityEnabled	
boolean

Optional. Whether this purchase option allows multi-quantity. Multi-quantity allows buyer to purchase more than one item in a single checkout.

OneTimeProductRentPurchaseOption
A purchase option that can be rented.

JSON representation

{
  "rentalPeriod": string,
  "expirationPeriod": string
}
Fields
rentalPeriod	
string

Required. The amount of time a user has the entitlement for. Starts at purchase flow completion. Specified in ISO 8601 format.

expirationPeriod	
string

Optional. The amount of time the user has after starting consuming the entitlement before it is revoked. Specified in ISO 8601 format.

RegionalPricingAndAvailabilityConfig
Regional pricing and availability configuration for a purchase option.

JSON representation

{
  "regionCode": string,
  "price": {
    object (Money)
  },
  "availability": enum (Availability)
}
Fields
regionCode	
string

Required. Region code this configuration applies to, as defined by ISO 3166-2, e.g., "US".

price	
object (Money)

The price of the purchase option in the specified region. Must be set in the currency that is linked to the specified region.

availability	
enum (Availability)

The availability of the purchase option.

Availability
The availability of the purchase option.

Enums
AVAILABILITY_UNSPECIFIED	Unspecified availability. Must not be used.
AVAILABLE	The purchase option is available to users.
NO_LONGER_AVAILABLE	The purchase option is no longer available to users. This value can only be used if the availability was previously set as AVAILABLE.
AVAILABLE_IF_RELEASED	The purchase option is initially unavailable, but made available via a released pre-order offer.
OneTimeProductPurchaseOptionNewRegionsConfig
Pricing information for any new regions Play may launch in the future.

JSON representation

{
  "usdPrice": {
    object (Money)
  },
  "eurPrice": {
    object (Money)
  },
  "availability": enum (Availability)
}
Fields
usdPrice	
object (Money)

Required. Price in USD to use for any new regions Play may launch in.

eurPrice	
object (Money)

Required. Price in EUR to use for any new regions Play may launch in.

availability	
enum (Availability)

Required. The regional availability for the new regions config. When set to AVAILABLE, the pricing information will be used for any new regions Play may launch in the future.

Availability
The availability of the new regions config.

Enums
AVAILABILITY_UNSPECIFIED	Unspecified availability. Must not be used.
AVAILABLE	The config will be used for any new regions Play may launch in the future.
NO_LONGER_AVAILABLE	The config is not available anymore and will not be used for any new regions Play may launch in the future. This value can only be used if the availability was previously set as AVAILABLE.
PurchaseOptionTaxAndComplianceSettings
Details about taxation, Google Play policy and legal compliance for one-time product purchase options.

JSON representation

{
  "withdrawalRightType": enum (WithdrawalRightType)
}
Fields
withdrawalRightType	
enum (WithdrawalRightType)

Optional. Digital content or service classification for products distributed to users in eligible regions.

If unset, it defaults to WITHDRAWAL_RIGHT_DIGITAL_CONTENT.

Refer to the Help Center article for more information.

Methods
batchDelete
Deletes one or more one-time products.
batchGet
Reads one or more one-time products.
batchUpdate
Creates or updates one or more one-time products.
delete
Deletes a one-time product.
get
Reads a single one-time product.
list
Lists all one-time products under a given app.
patch
Creates or updates a one-time product.
