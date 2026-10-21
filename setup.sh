read -p "Supabase URL: " U
read -p "Supabase anon key: " K
sed -i "s|^const supabaseUrl = .*|const supabaseUrl = '$U';|" lib/main.dart
sed -i "s|^const supabaseKey = .*|const supabaseKey = '$K';|" lib/main.dart
echo Done
