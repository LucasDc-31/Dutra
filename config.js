const SUPABASE_URL = 'https://ceuxijusuztnkvyrdzbd.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNldXhpanVzdXp0bmt2eXJkemJkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI3MDU4NTgsImV4cCI6MjEwODI4MTg1OH0.dcBC7og-UYVmJeio4PbGoWgsBWe9SYcHunUzthnPJAQ';

// true quando a URL e a chave acima ja foram preenchidas de verdade.
function supabaseConfigurado() {
  return !!(SUPABASE_URL && SUPABASE_ANON_KEY
    && !SUPABASE_URL.includes('SEU-PROJETO')
    && !SUPABASE_ANON_KEY.includes('SUA_CHAVE_ANON'));
}