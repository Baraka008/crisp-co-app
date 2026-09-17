# Crisp & Co.

A polished chicken ordering experience with a customer storefront and a seller operations hub.

## Open The Site

With the local server running:

- Customer ordering site: [http://localhost:5500](http://localhost:5500)
- Seller dashboard: [http://localhost:5500/seller.html](http://localhost:5500/seller.html)
- GitHub repository: [https://github.com/Baraka008/crisp-co-app](https://github.com/Baraka008/crisp-co-app)

## What It Includes

### Customer experience

- Bold responsive storefront with food photography
- Seller-managed menu display
- Menu categories and search
- Favorite items saved in the browser
- Shopping cart with quantity controls
- Country and currency selection
- Location detection with currency support
- Promo code support with `CRUNCH10`
- Delivery details and payment form
- Order confirmation and preparation tracking

### Seller experience

- Store overview dashboard
- Live order queue
- Accept new orders
- Move orders from in progress to ready
- Add menu items with price, category, description, availability, and image
- Hide or remove menu items
- Booking confirmation workflow
- Revenue and operational insight areas
- Responsive seller layout for smaller screens

## Customer And Seller Connection

The customer and seller pages share browser storage while running on the same local origin:

1. A seller adds or changes a menu item.
2. The customer storefront receives the available menu.
3. A customer completes checkout.
4. The order is written to the shared seller order queue.
5. The seller dashboard displays the new order as `New`.
6. The seller can accept it and mark it `Ready`.

The demo data is stored under versioned local keys so the project is easy to reset or replace with a real backend later.

## Demo Data

On a fresh browser profile, the seller dashboard seeds a small demonstration dataset:

- Three menu items
- Two sample orders
- Two sample bookings

After you edit the menu or process an order, your changes are retained in browser storage.

## Run Locally

From the project directory:

```powershell
python -m http.server 5500
```

Then open [http://localhost:5500](http://localhost:5500).

A local server is recommended because browser storage, fetch requests, and page-to-page behavior are more reliable over HTTP than by opening the HTML files directly.

## Project Structure

```text
index.html       Customer storefront
app.js           Customer cart, pricing, checkout, and shared order publishing
styles.css       Customer storefront styles
seller.html      Seller dashboard
seller.js        Seller menu, orders, bookings, and shared data handling
seller.css       Seller dashboard styles
assets/          Local food photography used by the demo
README.md        Project documentation
```

## Production Note

The current version is a front-end demo using browser `localStorage`. It is suitable for local demonstrations and a single browser profile. For production use across customers, sellers, and devices, connect the shared collections to Supabase with authentication, PostgreSQL tables, Row Level Security, Storage, and Realtime subscriptions.

## License

No license has been added yet. Add one before distributing the project publicly.
