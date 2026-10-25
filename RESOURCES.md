# E-commerce System Design Resources

## Knowledge

### Data model & catalog
- [Docs: Saleor, "Product Overview"](https://docs.saleor.io/developer/products/overview)
  Short, developer-first explanation of product vs variant vs product type. Says plainly that "checkout and orders can only contain variants" and that prices and stock live on the variant. Use for: catalog modelling, which attributes go where.
- [Docs: Shopify, "About products and collections"](https://shopify.dev/docs/apps/build/product-merchandising/products-and-collections)
  How the largest commerce platform models products, options and variants, with real limits (2,048 variants per product). Use for: checking your catalog model against production practice.
- [Changelog: Shopify, "The product variant limit is now 2048 for all merchants"](https://shopify.dev/changelog/the-product-variant-limit-is-now-2048-for-all-merchants)
  Use for: an example of how variant explosion shows up as a real product constraint.
- [Docs: Medusa, Product Module](https://docs.medusajs.com/resources/commerce-modules/product) and [ProductVariant model](https://docs.medusajs.com/resources/references/product/models/ProductVariant)
  Open-source, TypeScript, modular commerce engine. Its modules (Product, Pricing, Inventory, Cart, Order, Payment) are a good map of commerce subsystems. Use for: reading a real, readable implementation; module boundaries; variant↔inventory links.

### Payments & reliability
- [Docs: Stripe, "Idempotent requests"](https://docs.stripe.com/api/idempotent_requests)
  How to retry payment calls without charging twice. Use for: checkout/payment flow, retries, failure handling.

### Checkout UX (business outcomes)
- [Research: Baymard Institute, Checkout Usability](https://baymard.com/research/checkout-usability) and [cart abandonment rate list](https://baymard.com/lists/cart-abandonment-rate)
  Large-scale usability research on checkout (average documented abandonment around 70%). Use for: justifying checkout design decisions with evidence.

### Reference implementations
- [Code: vercel/commerce (Next.js Commerce)](https://github.com/vercel/commerce)
  App Router storefront using Server Components, Server Actions and useOptimistic. Use for: Next.js storefront patterns when migrating The Edit (its backend is Shopify, so not for data modelling).

### Scale & real-world operations
- [Article: Shopify Engineering, "Surviving Flashes of High Write Traffic Using Scriptable Load Balancers"](https://engineering.shopify.com/surviving-flashes-of-high-write-traffic-using-scriptable-load-balancers-part-i)
  How Shopify throttles checkout during flash sales. Use for: interview-level "what happens at scale" talking points.
- [Talk: Bart de Water, "Shopify's Architecture to Handle the World's Biggest Flash Sales" (InfoQ)](https://www.infoq.com/presentations/shopify-architecture-flash-sale/)
  Use for: multi-tenant architecture, preparing for Black Friday.

### Postgres
- [Docs: PostgreSQL, Constraints](https://www.postgresql.org/docs/current/ddl-constraints.html)
  Use for: unique, check and foreign-key constraints that enforce commerce rules in the database.

## Wisdom (Communities)

- [Medusa Discord & GitHub Discussions](https://github.com/medusajs/medusa)
  Active community of developers building custom commerce on a JS stack. Use for: asking "how would you model X" and seeing real problems.
- [r/webdev](https://www.reddit.com/r/webdev/) and [r/ExperiencedDevs](https://www.reddit.com/r/ExperiencedDevs/)
  Use for: portfolio and project feedback (r/webdev), hiring and interview expectations (r/ExperiencedDevs, which has stricter posting rules).

## Gaps
- A high-trust, vendor-neutral source on order lifecycle and state machines (returns, refunds, partial fulfilment).
- A high-trust source on inventory reservation strategies (reserve at add-to-cart vs at checkout).
- Business side: how pricing, margins, promotions and returns are run operationally.
