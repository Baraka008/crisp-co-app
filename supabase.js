const supabaseClient = window.supabase && window.SUPABASE_URL && window.SUPABASE_PUBLISHABLE_KEY
  ? window.supabase.createClient(window.SUPABASE_URL, window.SUPABASE_PUBLISHABLE_KEY)
  : null;

async function supabaseReadMenu() {
  if (!supabaseClient) return [];
  const { data, error } = await supabaseClient.from('menu_items').select('*').eq('available', true).order('created_at');
  if (error) throw error;
  return data || [];
}

async function supabaseReadOrders() {
  if (!supabaseClient) return [];
  const { data, error } = await supabaseClient.from('orders').select('*').order('created_at', { ascending: false });
  if (error) throw error;
  return data || [];
}

async function supabaseSaveMenu(menu) {
  if (!supabaseClient || !menu.length) return;
  const { error } = await supabaseClient.from('menu_items').upsert(menu.map(item => ({
    id: item.id, name: item.name, description: item.description || item.desc || '', price: item.price,
    category: item.category, image: item.image || '', tag: item.tag || '', available: item.available !== false
  })));
  if (error) throw error;
}

async function supabaseSaveOrder(order) {
  if (!supabaseClient) return;
  const { error } = await supabaseClient.from('orders').upsert(order);
  if (error) throw error;
}

function supabaseWatchOrders(onChange) {
  if (!supabaseClient) return null;
  return supabaseClient.channel('crisp-orders-live').on('postgres_changes', { event: '*', schema: 'public', table: 'orders' }, onChange).subscribe();
}

function supabaseWatchMenu(onChange) {
  if (!supabaseClient) return null;
  return supabaseClient.channel('crisp-menu-live').on('postgres_changes', { event: '*', schema: 'public', table: 'menu_items' }, onChange).subscribe();
}
