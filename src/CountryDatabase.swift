import Foundation

enum CountryDatabase {

    static let allItems: [CountryItem] = officialCountries + territories

    // MARK: - 197 Official Countries
    static let officialCountries: [CountryItem] = [
        // MARK: Europe (45)
        CountryItem(id: "AL", name: "Albania", capital: "Tirana", flag: "🇦🇱", continent: "Europe"),
        CountryItem(id: "AD", name: "Andorra", capital: "Andorra la Vella", flag: "🇦🇩", continent: "Europe"),
        CountryItem(id: "AT", name: "Austria", capital: "Vienna", flag: "🇦🇹", continent: "Europe"),
        CountryItem(id: "BY", name: "Belarus", capital: "Minsk", flag: "🇧🇾", continent: "Europe"),
        CountryItem(id: "BE", name: "Belgium", capital: "Brussels", flag: "🇧🇪", continent: "Europe"),
        CountryItem(id: "BA", name: "Bosnia and Herzegovina", capital: "Sarajevo", flag: "🇧🇦", continent: "Europe"),
        CountryItem(id: "BG", name: "Bulgaria", capital: "Sofia", flag: "🇧🇬", continent: "Europe"),
        CountryItem(id: "HR", name: "Croatia", capital: "Zagreb", flag: "🇭🇷", continent: "Europe"),
        CountryItem(id: "CY", name: "Cyprus", capital: "Nicosia", flag: "🇨🇾", continent: "Europe"),
        CountryItem(id: "CZ", name: "Czechia", capital: "Prague", flag: "🇨🇿", continent: "Europe"),
        CountryItem(id: "DK", name: "Denmark", capital: "Copenhagen", flag: "🇩🇰", continent: "Europe"),
        CountryItem(id: "EE", name: "Estonia", capital: "Tallinn", flag: "🇪🇪", continent: "Europe"),
        CountryItem(id: "FI", name: "Finland", capital: "Helsinki", flag: "🇫🇮", continent: "Europe"),
        CountryItem(id: "FR", name: "France", capital: "Paris", flag: "🇫🇷", continent: "Europe"),
        CountryItem(id: "DE", name: "Germany", capital: "Berlin", flag: "🇩🇪", continent: "Europe"),
        CountryItem(id: "GR", name: "Greece", capital: "Athens", flag: "🇬🇷", continent: "Europe"),
        CountryItem(id: "HU", name: "Hungary", capital: "Budapest", flag: "🇭🇺", continent: "Europe"),
        CountryItem(id: "IS", name: "Iceland", capital: "Reykjavik", alternateCapitals: ["Reykjavík"], flag: "🇮🇸", continent: "Europe"),
        CountryItem(id: "IE", name: "Ireland", capital: "Dublin", flag: "🇮🇪", continent: "Europe"),
        CountryItem(id: "IT", name: "Italy", capital: "Rome", flag: "🇮🇹", continent: "Europe"),
        CountryItem(id: "XK", name: "Kosovo", capital: "Pristina", alternateCapitals: ["Prishtina"], flag: "🇽🇰", continent: "Europe"),
        CountryItem(id: "LV", name: "Latvia", capital: "Riga", flag: "🇱🇻", continent: "Europe"),
        CountryItem(id: "LI", name: "Liechtenstein", capital: "Vaduz", flag: "🇱🇮", continent: "Europe"),
        CountryItem(id: "LT", name: "Lithuania", capital: "Vilnius", flag: "🇱🇹", continent: "Europe"),
        CountryItem(id: "LU", name: "Luxembourg", capital: "Luxembourg", alternateCapitals: ["Luxembourg City"], flag: "🇱🇺", continent: "Europe"),
        CountryItem(id: "MT", name: "Malta", capital: "Valletta", flag: "🇲🇹", continent: "Europe"),
        CountryItem(id: "MD", name: "Moldova", capital: "Chisinau", alternateCapitals: ["Chișinău"], flag: "🇲🇩", continent: "Europe"),
        CountryItem(id: "MC", name: "Monaco", capital: "Monaco", alternateCapitals: ["Monaco-Ville"], flag: "🇲🇨", continent: "Europe"),
        CountryItem(id: "ME", name: "Montenegro", capital: "Podgorica", alternateCapitals: ["Cetinje"], flag: "🇲🇪", continent: "Europe"),
        CountryItem(id: "NL", name: "Netherlands", capital: "Amsterdam", alternateCapitals: ["The Hague"], flag: "🇳🇱", continent: "Europe"),
        CountryItem(id: "MK", name: "North Macedonia", capital: "Skopje", flag: "🇲🇰", continent: "Europe"),
        CountryItem(id: "NO", name: "Norway", capital: "Oslo", flag: "🇳🇴", continent: "Europe"),
        CountryItem(id: "PL", name: "Poland", capital: "Warsaw", flag: "🇵🇱", continent: "Europe"),
        CountryItem(id: "PT", name: "Portugal", capital: "Lisbon", flag: "🇵🇹", continent: "Europe"),
        CountryItem(id: "RO", name: "Romania", capital: "Bucharest", flag: "🇷🇴", continent: "Europe"),
        CountryItem(id: "RU", name: "Russia", capital: "Moscow", flag: "🇷🇺", continent: "Europe"),
        CountryItem(id: "SM", name: "San Marino", capital: "San Marino", alternateCapitals: ["City of San Marino"], flag: "🇸🇲", continent: "Europe"),
        CountryItem(id: "RS", name: "Serbia", capital: "Belgrade", flag: "🇷🇸", continent: "Europe"),
        CountryItem(id: "SK", name: "Slovakia", capital: "Bratislava", flag: "🇸🇰", continent: "Europe"),
        CountryItem(id: "SI", name: "Slovenia", capital: "Ljubljana", flag: "🇸🇮", continent: "Europe"),
        CountryItem(id: "ES", name: "Spain", capital: "Madrid", flag: "🇪🇸", continent: "Europe"),
        CountryItem(id: "SE", name: "Sweden", capital: "Stockholm", flag: "🇸🇪", continent: "Europe"),
        CountryItem(id: "CH", name: "Switzerland", capital: "Bern", alternateCapitals: ["Berne"], flag: "🇨🇭", continent: "Europe"),
        CountryItem(id: "UA", name: "Ukraine", capital: "Kyiv", alternateCapitals: ["Kiev"], flag: "🇺🇦", continent: "Europe"),
        CountryItem(id: "GB", name: "United Kingdom", capital: "London", flag: "🇬🇧", continent: "Europe"),
        CountryItem(id: "VA", name: "Vatican City", capital: "Vatican City", flag: "🇻🇦", continent: "Europe"),

        // MARK: Asia (49)
        CountryItem(id: "AF", name: "Afghanistan", capital: "Kabul", flag: "🇦🇫", continent: "Asia"),
        CountryItem(id: "AM", name: "Armenia", capital: "Yerevan", flag: "🇦🇲", continent: "Asia"),
        CountryItem(id: "AZ", name: "Azerbaijan", capital: "Baku", flag: "🇦🇿", continent: "Asia"),
        CountryItem(id: "BH", name: "Bahrain", capital: "Manama", flag: "🇧🇭", continent: "Asia"),
        CountryItem(id: "BD", name: "Bangladesh", capital: "Dhaka", flag: "🇧🇩", continent: "Asia"),
        CountryItem(id: "BT", name: "Bhutan", capital: "Thimphu", flag: "🇧🇹", continent: "Asia"),
        CountryItem(id: "BN", name: "Brunei", capital: "Bandar Seri Begawan", flag: "🇧🇳", continent: "Asia"),
        CountryItem(id: "KH", name: "Cambodia", capital: "Phnom Penh", flag: "🇰🇭", continent: "Asia"),
        CountryItem(id: "CN", name: "China", capital: "Beijing", flag: "🇨🇳", continent: "Asia"),
        CountryItem(id: "GE", name: "Georgia", capital: "Tbilisi", flag: "🇬🇪", continent: "Asia"),
        CountryItem(id: "IN", name: "India", capital: "New Delhi", alternateCapitals: ["Delhi"], flag: "🇮🇳", continent: "Asia"),
        CountryItem(id: "ID", name: "Indonesia", capital: "Jakarta", alternateCapitals: ["Nusantara"], flag: "🇮🇩", continent: "Asia"),
        CountryItem(id: "IR", name: "Iran", capital: "Tehran", flag: "🇮🇷", continent: "Asia"),
        CountryItem(id: "IQ", name: "Iraq", capital: "Baghdad", flag: "🇮🇶", continent: "Asia"),
        CountryItem(id: "IL", name: "Israel", capital: "Jerusalem", flag: "🇮🇱", continent: "Asia"),
        CountryItem(id: "JP", name: "Japan", capital: "Tokyo", flag: "🇯🇵", continent: "Asia"),
        CountryItem(id: "JO", name: "Jordan", capital: "Amman", flag: "🇯🇴", continent: "Asia"),
        CountryItem(id: "KZ", name: "Kazakhstan", capital: "Astana", alternateCapitals: ["Nur-Sultan"], flag: "🇰🇿", continent: "Asia"),
        CountryItem(id: "KW", name: "Kuwait", capital: "Kuwait City", alternateCapitals: ["Kuwait"], flag: "🇰🇼", continent: "Asia"),
        CountryItem(id: "KG", name: "Kyrgyzstan", capital: "Bishkek", flag: "🇰🇬", continent: "Asia"),
        CountryItem(id: "LA", name: "Laos", capital: "Vientiane", flag: "🇱🇦", continent: "Asia"),
        CountryItem(id: "LB", name: "Lebanon", capital: "Beirut", flag: "🇱🇧", continent: "Asia"),
        CountryItem(id: "MY", name: "Malaysia", capital: "Kuala Lumpur", alternateCapitals: ["Putrajaya"], flag: "🇲🇾", continent: "Asia"),
        CountryItem(id: "MV", name: "Maldives", capital: "Male", alternateCapitals: ["Malé"], flag: "🇲🇻", continent: "Asia"),
        CountryItem(id: "MN", name: "Mongolia", capital: "Ulaanbaatar", alternateCapitals: ["Ulan Bator"], flag: "🇲🇳", continent: "Asia"),
        CountryItem(id: "MM", name: "Myanmar", capital: "Naypyidaw", alternateCapitals: ["Nay Pyi Taw"], flag: "🇲🇲", continent: "Asia"),
        CountryItem(id: "NP", name: "Nepal", capital: "Kathmandu", flag: "🇳🇵", continent: "Asia"),
        CountryItem(id: "KP", name: "North Korea", capital: "Pyongyang", flag: "🇰🇵", continent: "Asia"),
        CountryItem(id: "OM", name: "Oman", capital: "Muscat", flag: "🇴🇲", continent: "Asia"),
        CountryItem(id: "PK", name: "Pakistan", capital: "Islamabad", flag: "🇵🇰", continent: "Asia"),
        CountryItem(id: "PS", name: "Palestine", capital: "Ramallah", alternateCapitals: ["East Jerusalem", "Jerusalem"], flag: "🇵🇸", continent: "Asia"),
        CountryItem(id: "PH", name: "Philippines", capital: "Manila", flag: "🇵🇭", continent: "Asia"),
        CountryItem(id: "QA", name: "Qatar", capital: "Doha", flag: "🇶🇦", continent: "Asia"),
        CountryItem(id: "SA", name: "Saudi Arabia", capital: "Riyadh", flag: "🇸🇦", continent: "Asia"),
        CountryItem(id: "SG", name: "Singapore", capital: "Singapore", flag: "🇸🇬", continent: "Asia"),
        CountryItem(id: "KR", name: "South Korea", capital: "Seoul", flag: "🇰🇷", continent: "Asia"),
        CountryItem(id: "LK", name: "Sri Lanka", capital: "Sri Jayawardenepura Kotte", alternateCapitals: ["Colombo", "Kotte"], flag: "🇱🇰", continent: "Asia"),
        CountryItem(id: "SY", name: "Syria", capital: "Damascus", flag: "🇸🇾", continent: "Asia"),
        CountryItem(id: "TW", name: "Taiwan", capital: "Taipei", flag: "🇹🇼", continent: "Asia"),
        CountryItem(id: "TJ", name: "Tajikistan", capital: "Dushanbe", flag: "🇹🇯", continent: "Asia"),
        CountryItem(id: "TH", name: "Thailand", capital: "Bangkok", flag: "🇹🇭", continent: "Asia"),
        CountryItem(id: "TL", name: "Timor-Leste", capital: "Dili", flag: "🇹🇱", continent: "Asia"),
        CountryItem(id: "TR", name: "Turkey", capital: "Ankara", flag: "🇹🇷", continent: "Asia"),
        CountryItem(id: "TM", name: "Turkmenistan", capital: "Ashgabat", flag: "🇹🇲", continent: "Asia"),
        CountryItem(id: "AE", name: "United Arab Emirates", capital: "Abu Dhabi", flag: "🇦🇪", continent: "Asia"),
        CountryItem(id: "UZ", name: "Uzbekistan", capital: "Tashkent", flag: "🇺🇿", continent: "Asia"),
        CountryItem(id: "VN", name: "Vietnam", capital: "Hanoi", flag: "🇻🇳", continent: "Asia"),
        CountryItem(id: "YE", name: "Yemen", capital: "Sanaa", alternateCapitals: ["Sana'a"], flag: "🇾🇪", continent: "Asia"),

        // MARK: Africa (54)
        CountryItem(id: "DZ", name: "Algeria", capital: " Algiers", alternateCapitals: ["Algiers"], flag: "🇩🇿", continent: "Africa"),
        CountryItem(id: "AO", name: "Angola", capital: "Luanda", flag: "🇦🇴", continent: "Africa"),
        CountryItem(id: "BJ", name: "Benin", capital: "Porto-Novo", alternateCapitals: ["Cotonou"], flag: "🇧🇯", continent: "Africa"),
        CountryItem(id: "BW", name: "Botswana", capital: "Gaborone", flag: "🇧🇼", continent: "Africa"),
        CountryItem(id: "BF", name: "Burkina Faso", capital: "Ouagadougou", flag: "🇧🇫", continent: "Africa"),
        CountryItem(id: "BI", name: "Burundi", capital: "Gitega", alternateCapitals: ["Bujumbura"], flag: "🇧🇮", continent: "Africa"),
        CountryItem(id: "CV", name: "Cabo Verde", capital: "Praia", flag: "🇨🇻", continent: "Africa"),
        CountryItem(id: "CM", name: "Cameroon", capital: "Yaounde", alternateCapitals: ["Yaoundé"], flag: "🇨🇲", continent: "Africa"),
        CountryItem(id: "CF", name: "Central African Republic", capital: "Bangui", flag: "🇨🇫", continent: "Africa"),
        CountryItem(id: "TD", name: "Chad", capital: "N'Djamena", alternateCapitals: ["NDjamena"], flag: "🇹🇩", continent: "Africa"),
        CountryItem(id: "KM", name: "Comoros", capital: "Moroni", flag: "🇰🇲", continent: "Africa"),
        CountryItem(id: "CG", name: "Republic of the Congo", capital: "Brazzaville", flag: "🇨🇬", continent: "Africa"),
        CountryItem(id: "CD", name: "DR Congo", capital: "Kinshasa", flag: "🇨🇩", continent: "Africa"),
        CountryItem(id: "CI", name: "Ivory Coast", capital: "Yamoussoukro", alternateCapitals: ["Abidjan"], flag: "🇨🇮", continent: "Africa"),
        CountryItem(id: "DJ", name: "Djibouti", capital: "Djibouti", alternateCapitals: ["Djibouti City"], flag: "🇩🇯", continent: "Africa"),
        CountryItem(id: "EG", name: "Egypt", capital: "Cairo", flag: "🇪🇬", continent: "Africa"),
        CountryItem(id: "GQ", name: "Equatorial Guinea", capital: "Malabo", alternateCapitals: ["Ciudad de la Paz"], flag: "🇬🇶", continent: "Africa"),
        CountryItem(id: "ER", name: "Eritrea", capital: "Asmara", flag: "🇪🇷", continent: "Africa"),
        CountryItem(id: "SZ", name: "Eswatini", capital: "Mbabane", alternateCapitals: ["Lobamba"], flag: "🇸🇿", continent: "Africa"),
        CountryItem(id: "ET", name: "Ethiopia", capital: "Addis Ababa", flag: "🇪🇹", continent: "Africa"),
        CountryItem(id: "GA", name: "Gabon", capital: "Libreville", flag: "🇬🇦", continent: "Africa"),
        CountryItem(id: "GM", name: "Gambia", capital: "Banjul", flag: "🇬🇲", continent: "Africa"),
        CountryItem(id: "GH", name: "Ghana", capital: "Accra", flag: "🇬🇭", continent: "Africa"),
        CountryItem(id: "GN", name: "Guinea", capital: "Conakry", flag: "🇬🇳", continent: "Africa"),
        CountryItem(id: "GW", name: "Guinea-Bissau", capital: "Bissau", flag: "🇬🇼", continent: "Africa"),
        CountryItem(id: "KE", name: "Kenya", capital: "Nairobi", flag: "🇰🇪", continent: "Africa"),
        CountryItem(id: "LS", name: "Lesotho", capital: "Maseru", flag: "🇱🇸", continent: "Africa"),
        CountryItem(id: "LR", name: "Liberia", capital: "Monrovia", flag: "🇱🇷", continent: "Africa"),
        CountryItem(id: "LY", name: "Libya", capital: "Tripoli", flag: "🇱🇾", continent: "Africa"),
        CountryItem(id: "MG", name: "Madagascar", capital: "Antananarivo", flag: "🇲🇬", continent: "Africa"),
        CountryItem(id: "MW", name: "Malawi", capital: "Lilongwe", flag: "🇲🇼", continent: "Africa"),
        CountryItem(id: "ML", name: "Mali", capital: "Bamako", flag: "🇲🇱", continent: "Africa"),
        CountryItem(id: "MR", name: "Mauritania", capital: "Nouakchott", flag: "🇲🇷", continent: "Africa"),
        CountryItem(id: "MU", name: "Mauritius", capital: "Port Louis", flag: "🇲🇺", continent: "Africa"),
        CountryItem(id: "MA", name: "Morocco", capital: "Rabat", flag: "🇲🇦", continent: "Africa"),
        CountryItem(id: "MZ", name: "Mozambique", capital: "Maputo", flag: "🇲🇿", continent: "Africa"),
        CountryItem(id: "NA", name: "Namibia", capital: "Windhoek", flag: "🇳🇦", continent: "Africa"),
        CountryItem(id: "NE", name: "Niger", capital: "Niamey", flag: "🇳🇪", continent: "Africa"),
        CountryItem(id: "NG", name: "Nigeria", capital: "Abuja", flag: "🇳🇬", continent: "Africa"),
        CountryItem(id: "RW", name: "Rwanda", capital: "Kigali", flag: "🇷🇼", continent: "Africa"),
        CountryItem(id: "ST", name: "Sao Tome and Principe", capital: "Sao Tome", alternateCapitals: ["São Tomé"], flag: "🇸🇹", continent: "Africa"),
        CountryItem(id: "SN", name: "Senegal", capital: "Dakar", flag: "🇸🇳", continent: "Africa"),
        CountryItem(id: "SC", name: "Seychelles", capital: "Victoria", flag: "🇸🇨", continent: "Africa"),
        CountryItem(id: "SL", name: "Sierra Leone", capital: "Freetown", flag: "🇸🇱", continent: "Africa"),
        CountryItem(id: "SO", name: "Somalia", capital: "Mogadishu", flag: "🇸🇴", continent: "Africa"),
        CountryItem(id: "ZA", name: "South Africa", capital: "Pretoria", alternateCapitals: ["Cape Town", "Bloemfontein"], flag: "🇿🇦", continent: "Africa"),
        CountryItem(id: "SS", name: "South Sudan", capital: "Juba", flag: "🇸🇸", continent: "Africa"),
        CountryItem(id: "SD", name: "Sudan", capital: "Khartoum", flag: "🇸🇩", continent: "Africa"),
        CountryItem(id: "TZ", name: "Tanzania", capital: "Dodoma", alternateCapitals: ["Dar es Salaam"], flag: "🇹🇿", continent: "Africa"),
        CountryItem(id: "TG", name: "Togo", capital: "Lome", alternateCapitals: ["Lomé"], flag: "🇹🇬", continent: "Africa"),
        CountryItem(id: "TN", name: "Tunisia", capital: "Tunis", flag: "🇹🇳", continent: "Africa"),
        CountryItem(id: "UG", name: "Uganda", capital: "Kampala", flag: "🇺🇬", continent: "Africa"),
        CountryItem(id: "ZM", name: "Zambia", capital: "Lusaka", flag: "🇿🇲", continent: "Africa"),
        CountryItem(id: "ZW", name: "Zimbabwe", capital: "Harare", flag: "🇿🇼", continent: "Africa"),

        // MARK: North America (23)
        CountryItem(id: "AG", name: "Antigua and Barbuda", capital: "Saint John's", alternateCapitals: ["St. John's"], flag: "🇦🇬", continent: "North America"),
        CountryItem(id: "BS", name: "Bahamas", capital: "Nassau", flag: "🇧🇸", continent: "North America"),
        CountryItem(id: "BB", name: "Barbados", capital: "Bridgetown", flag: "🇧🇧", continent: "North America"),
        CountryItem(id: "BZ", name: "Belize", capital: "Belmopan", flag: "🇧🇿", continent: "North America"),
        CountryItem(id: "CA", name: "Canada", capital: "Ottawa", flag: "🇨🇦", continent: "North America"),
        CountryItem(id: "CR", name: "Costa Rica", capital: "San Jose", alternateCapitals: ["San José"], flag: "🇨🇷", continent: "North America"),
        CountryItem(id: "CU", name: "Cuba", capital: "Havana", flag: "🇨🇺", continent: "North America"),
        CountryItem(id: "DM", name: "Dominica", capital: "Roseau", flag: "🇩🇲", continent: "North America"),
        CountryItem(id: "DO", name: "Dominican Republic", capital: "Santo Domingo", flag: "🇩🇴", continent: "North America"),
        CountryItem(id: "SV", name: "El Salvador", capital: "San Salvador", flag: "🇸🇻", continent: "North America"),
        CountryItem(id: "GD", name: "Grenada", capital: "Saint George's", alternateCapitals: ["St. George's"], flag: "🇬🇩", continent: "North America"),
        CountryItem(id: "GT", name: "Guatemala", capital: "Guatemala City", alternateCapitals: ["Guatemala"], flag: "🇬🇹", continent: "North America"),
        CountryItem(id: "HT", name: "Haiti", capital: "Port-au-Prince", flag: "🇭🇹", continent: "North America"),
        CountryItem(id: "HN", name: "Honduras", capital: "Tegucigalpa", flag: "🇭🇳", continent: "North America"),
        CountryItem(id: "JM", name: "Jamaica", capital: "Kingston", flag: "🇯🇲", continent: "North America"),
        CountryItem(id: "MX", name: "Mexico", capital: "Mexico City", alternateCapitals: ["Mexico"], flag: "🇲🇽", continent: "North America"),
        CountryItem(id: "NI", name: "Nicaragua", capital: "Managua", flag: "🇳🇮", continent: "North America"),
        CountryItem(id: "PA", name: "Panama", capital: "Panama City", alternateCapitals: ["Panama"], flag: "🇵🇦", continent: "North America"),
        CountryItem(id: "KN", name: "Saint Kitts and Nevis", capital: "Basseterre", flag: "🇰🇳", continent: "North America"),
        CountryItem(id: "LC", name: "Saint Lucia", capital: "Castries", flag: "🇱🇨", continent: "North America"),
        CountryItem(id: "VC", name: "Saint Vincent and the Grenadines", capital: "Kingstown", flag: "🇻🇨", continent: "North America"),
        CountryItem(id: "TT", name: "Trinidad and Tobago", capital: "Port of Spain", flag: "🇹🇹", continent: "North America"),
        CountryItem(id: "US", name: "United States", capital: "Washington, D.C.", alternateCapitals: ["Washington DC", "Washington"], flag: "🇺🇸", continent: "North America"),

        // MARK: South America (12)
        CountryItem(id: "AR", name: "Argentina", capital: "Buenos Aires", flag: "🇦🇷", continent: "South America"),
        CountryItem(id: "BO", name: "Bolivia", capital: "Sucre", alternateCapitals: ["La Paz"], flag: "🇧🇴", continent: "South America"),
        CountryItem(id: "BR", name: "Brazil", capital: "Brasilia", alternateCapitals: ["Brasília"], flag: "🇧🇷", continent: "South America"),
        CountryItem(id: "CL", name: "Chile", capital: "Santiago", flag: "🇨🇱", continent: "South America"),
        CountryItem(id: "CO", name: "Colombia", capital: "Bogota", alternateCapitals: ["Bogotá"], flag: "🇨🇴", continent: "South America"),
        CountryItem(id: "EC", name: "Ecuador", capital: "Quito", flag: "🇪🇨", continent: "South America"),
        CountryItem(id: "GY", name: "Guyana", capital: "Georgetown", flag: "🇬🇾", continent: "South America"),
        CountryItem(id: "PY", name: "Paraguay", capital: "Asuncion", alternateCapitals: ["Asunción"], flag: "🇵🇾", continent: "South America"),
        CountryItem(id: "PE", name: "Peru", capital: "Lima", flag: "🇵🇪", continent: "South America"),
        CountryItem(id: "SR", name: "Suriname", capital: "Paramaribo", flag: "🇸🇷", continent: "South America"),
        CountryItem(id: "UY", name: "Uruguay", capital: "Montevideo", flag: "🇺🇾", continent: "South America"),
        CountryItem(id: "VE", name: "Venezuela", capital: "Caracas", flag: "🇻🇪", continent: "South America"),

        // MARK: Oceania (14)
        CountryItem(id: "AU", name: "Australia", capital: "Canberra", flag: "🇦🇺", continent: "Oceania"),
        CountryItem(id: "FJ", name: "Fiji", capital: "Suva", flag: "🇫🇯", continent: "Oceania"),
        CountryItem(id: "KI", name: "Kiribati", capital: "Tarawa", alternateCapitals: ["South Tarawa"], flag: "🇰🇮", continent: "Oceania"),
        CountryItem(id: "MH", name: "Marshall Islands", capital: "Majuro", flag: "🇲🇭", continent: "Oceania"),
        CountryItem(id: "FM", name: "Micronesia", capital: "Palikir", flag: "🇫🇲", continent: "Oceania"),
        CountryItem(id: "NR", name: "Nauru", capital: "Yaren", alternateCapitals: ["Yaren District"], flag: "🇳🇷", continent: "Oceania"),
        CountryItem(id: "NZ", name: "New Zealand", capital: "Wellington", flag: "🇳🇿", continent: "Oceania"),
        CountryItem(id: "PW", name: "Palau", capital: "Ngerulmud", flag: "🇵🇼", continent: "Oceania"),
        CountryItem(id: "PG", name: "Papua New Guinea", capital: "Port Moresby", flag: "🇵🇬", continent: "Oceania"),
        CountryItem(id: "WS", name: "Samoa", capital: "Apia", flag: "🇼🇸", continent: "Oceania"),
        CountryItem(id: "SB", name: "Solomon Islands", capital: "Honiara", flag: "🇸🇧", continent: "Oceania"),
        CountryItem(id: "TO", name: "Tonga", capital: "Nuku'alofa", alternateCapitals: ["Nukualofa"], flag: "🇹🇴", continent: "Oceania"),
        CountryItem(id: "TV", name: "Tuvalu", capital: "Funafuti", flag: "🇹🇻", continent: "Oceania"),
        CountryItem(id: "VU", name: "Vanuatu", capital: "Port Vila", flag: "🇻🇺", continent: "Oceania")
    ].map { item in
        // Ensure clean whitespace on capitals
        CountryItem(
            id: item.id,
            name: item.name.trimmingCharacters(in: .whitespacesAndNewlines),
            capital: item.capital.trimmingCharacters(in: .whitespacesAndNewlines),
            alternateCapitals: item.alternateCapitals,
            flag: item.flag,
            continent: item.continent,
            isTerritory: false
        )
    }

    // MARK: - 50 Dependent Territories, Overseas Regions & Constituent Countries
    static let territories: [CountryItem] = [
        // US Territories
        CountryItem(id: "AS", name: "American Samoa", capital: "Pago Pago", flag: "🇦🇸", continent: "Oceania", isTerritory: true),
        CountryItem(id: "GU", name: "Guam", capital: "Hagatna", alternateCapitals: ["Hagåtña", "Agana"], flag: "🇬🇺", continent: "Oceania", isTerritory: true),
        CountryItem(id: "MP", name: "Northern Mariana Islands", capital: "Saipan", flag: "🇲🇵", continent: "Oceania", isTerritory: true),
        CountryItem(id: "PR", name: "Puerto Rico", capital: "San Juan", flag: "🇵🇷", continent: "North America", isTerritory: true),
        CountryItem(id: "VI", name: "U.S. Virgin Islands", capital: "Charlotte Amalie", flag: "🇻🇮", continent: "North America", isTerritory: true),

        // UK Overseas Territories & Crown Dependencies
        CountryItem(id: "AI", name: "Anguilla", capital: "The Valley", flag: "🇦🇮", continent: "North America", isTerritory: true),
        CountryItem(id: "BM", name: "Bermuda", capital: "Hamilton", flag: "🇧🇲", continent: "North America", isTerritory: true),
        CountryItem(id: "VG", name: "British Virgin Islands", capital: "Road Town", flag: "🇻🇬", continent: "North America", isTerritory: true),
        CountryItem(id: "KY", name: "Cayman Islands", capital: "George Town", flag: "🇰🇾", continent: "North America", isTerritory: true),
        CountryItem(id: "FK", name: "Falkland Islands", capital: "Stanley", alternateCapitals: ["Port Stanley"], flag: "🇫🇰", continent: "South America", isTerritory: true),
        CountryItem(id: "GI", name: "Gibraltar", capital: "Gibraltar", flag: "🇬🇮", continent: "Europe", isTerritory: true),
        CountryItem(id: "GG", name: "Guernsey", capital: "Saint Peter Port", alternateCapitals: ["St. Peter Port"], flag: "🇬🇬", continent: "Europe", isTerritory: true),
        CountryItem(id: "IM", name: "Isle of Man", capital: "Douglas", flag: "🇮🇲", continent: "Europe", isTerritory: true),
        CountryItem(id: "JE", name: "Jersey", capital: "Saint Helier", alternateCapitals: ["St. Helier"], flag: "🇯🇪", continent: "Europe", isTerritory: true),
        CountryItem(id: "MS", name: "Montserrat", capital: "Plymouth", alternateCapitals: ["Brades"], flag: "🇲🇸", continent: "North America", isTerritory: true),
        CountryItem(id: "PN", name: "Pitcairn Islands", capital: "Adamstown", flag: "🇵🇳", continent: "Oceania", isTerritory: true),
        CountryItem(id: "SH", name: "Saint Helena", capital: "Jamestown", flag: "🇸🇭", continent: "Africa", isTerritory: true),
        CountryItem(id: "TC", name: "Turks and Caicos Islands", capital: "Cockburn Town", flag: "🇹🇨", continent: "North America", isTerritory: true),
        CountryItem(id: "SCT", name: "Scotland", capital: "Edinburgh", flag: "🏴󠁧󠁢󠁳󠁣󠁴󠁿", continent: "Europe", isTerritory: true),
        CountryItem(id: "WLS", name: "Wales", capital: "Cardiff", flag: "🏴󠁧󠁢󠁷󠁬󠁳󠁿", continent: "Europe", isTerritory: true),
        CountryItem(id: "NIR", name: "Northern Ireland", capital: "Belfast", flag: "🇬🇧", continent: "Europe", isTerritory: true),

        // French Overseas Territories & Collectivities
        CountryItem(id: "GF", name: "French Guiana", capital: "Cayenne", flag: "🇬🇫", continent: "South America", isTerritory: true),
        CountryItem(id: "PF", name: "French Polynesia", capital: "Papeete", flag: "🇵🇫", continent: "Oceania", isTerritory: true),
        CountryItem(id: "GP", name: "Guadeloupe", capital: "Basse-Terre", flag: "🇬🇵", continent: "North America", isTerritory: true),
        CountryItem(id: "MQ", name: "Martinique", capital: "Fort-de-France", flag: "🇲🇶", continent: "North America", isTerritory: true),
        CountryItem(id: "YT", name: "Mayotte", capital: "Mamoudzou", flag: "🇾🇹", continent: "Africa", isTerritory: true),
        CountryItem(id: "NC", name: "New Caledonia", capital: "Noumea", alternateCapitals: ["Nouméa"], flag: "🇳🇨", continent: "Oceania", isTerritory: true),
        CountryItem(id: "RE", name: "Reunion", capital: "Saint-Denis", flag: "🇷🇪", continent: "Africa", isTerritory: true),
        CountryItem(id: "BL", name: "Saint Barthelemy", capital: "Gustavia", flag: "🇧🇱", continent: "North America", isTerritory: true),
        CountryItem(id: "MF", name: "Saint Martin", capital: "Marigot", flag: "🇲🇫", continent: "North America", isTerritory: true),
        CountryItem(id: "PM", name: "Saint Pierre and Miquelon", capital: "Saint-Pierre", flag: "🇵🇲", continent: "North America", isTerritory: true),
        CountryItem(id: "WF", name: "Wallis and Futuna", capital: "Mata Utu", alternateCapitals: ["Mata-Utu"], flag: "🇼🇫", continent: "Oceania", isTerritory: true),

        // Dutch Caribbean Territories & Constituent Countries
        CountryItem(id: "AW", name: "Aruba", capital: "Oranjestad", flag: "🇦🇼", continent: "North America", isTerritory: true),
        CountryItem(id: "CW", name: "Curacao", capital: "Willemstad", flag: "🇨🇼", continent: "North America", isTerritory: true),
        CountryItem(id: "SX", name: "Sint Maarten", capital: "Philipsburg", flag: "🇸🇽", continent: "North America", isTerritory: true),
        CountryItem(id: "BQ-BO", name: "Bonaire", capital: "Kralendijk", flag: "🇧🇶", continent: "North America", isTerritory: true),
        CountryItem(id: "BQ-SA", name: "Saba", capital: "The Bottom", flag: "🇧🇶", continent: "North America", isTerritory: true),
        CountryItem(id: "BQ-SE", name: "Sint Eustatius", capital: "Oranjestad", flag: "🇧🇶", continent: "North America", isTerritory: true),

        // Danish Autonomous Territories
        CountryItem(id: "FO", name: "Faroe Islands", capital: "Torshavn", alternateCapitals: ["Tórshavn"], flag: "🇫🇴", continent: "Europe", isTerritory: true),
        CountryItem(id: "GL", name: "Greenland", capital: "Nuuk", flag: "🇬🇱", continent: "North America", isTerritory: true),

        // New Zealand & Australian Associated States / External Territories
        CountryItem(id: "CK", name: "Cook Islands", capital: "Avarua", flag: "🇨🇰", continent: "Oceania", isTerritory: true),
        CountryItem(id: "NU", name: "Niue", capital: "Alofi", flag: "🇳🇺", continent: "Oceania", isTerritory: true),
        CountryItem(id: "TK", name: "Tokelau", capital: "Fakaofo", alternateCapitals: ["Atafu", "Nukunonu"], flag: "🇹🇰", continent: "Oceania", isTerritory: true),
        CountryItem(id: "NF", name: "Norfolk Island", capital: "Kingston", flag: "🇳🇫", continent: "Oceania", isTerritory: true),
        CountryItem(id: "CX", name: "Christmas Island", capital: "Flying Fish Cove", flag: "🇨🇽", continent: "Asia", isTerritory: true),
        CountryItem(id: "CC", name: "Cocos (Keeling) Islands", capital: "West Island", flag: "🇨🇨", continent: "Asia", isTerritory: true),

        // Other Special Regions & Territories
        CountryItem(id: "HK", name: "Hong Kong", capital: "Hong Kong", alternateCapitals: ["Victoria", "Central"], flag: "🇭🇰", continent: "Asia", isTerritory: true),
        CountryItem(id: "MO", name: "Macau", capital: "Macau", alternateCapitals: ["Macao"], flag: "🇲🇴", continent: "Asia", isTerritory: true),
        CountryItem(id: "AX", name: "Aland Islands", capital: "Mariehamn", flag: "🇦🇽", continent: "Europe", isTerritory: true),
        CountryItem(id: "SJ", name: "Svalbard", capital: "Longyearbyen", flag: "🇸🇯", continent: "Europe", isTerritory: true),
        CountryItem(id: "EH", name: "Western Sahara", capital: "Laayoune", alternateCapitals: ["El Aaiun", "El Aaiún"], flag: "🇪🇭", continent: "Africa", isTerritory: true)
    ]

    // MARK: - String Normalization & Validation
    static func normalize(_ raw: String) -> String {
        var text = raw.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if text.isEmpty { return "" }

        // Fold accents and diacritics
        text = text.folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "en_US_POSIX"))

        // Explicit Nordic/European character replacements
        let specialMap: [String: String] = [
            "å": "a",
            "ø": "o",
            "æ": "ae",
            "œ": "oe",
            "ß": "ss",
            "đ": "d",
            "ł": "l",
            "’": "'",
            "‘": "'",
            "`": "'"
        ]
        for (k, v) in specialMap {
            text = text.replacingOccurrences(of: k, with: v)
        }

        // Normalize "st." or "st " at start to "saint "
        if text.hasPrefix("st. ") {
            text = "saint " + String(text.dropFirst(4))
        } else if text.hasPrefix("st ") {
            text = "saint " + String(text.dropFirst(3))
        }

        // Remove punctuation like periods, commas, apostrophes, and convert hyphens to spaces
        let punctuationToRemove: Set<Character> = [".", ",", "'", "\""]
        text.removeAll { punctuationToRemove.contains($0) }
        text = text.replacingOccurrences(of: "-", with: " ")

        // Collapse multiple spaces into one
        let components = text.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        return components.joined(separator: " ")
    }

    static func isAnswerCorrect(_ userInput: String, for country: CountryItem) -> (isCorrect: Bool, matchedCapital: String) {
        let normalizedInput = normalize(userInput)
        guard !normalizedInput.isEmpty else {
            return (false, country.capital)
        }

        for candidate in country.allAcceptedCapitals {
            if normalize(candidate) == normalizedInput {
                return (true, candidate)
            }
        }
        return (false, country.capital)
    }

    // MARK: - Autocomplete Suggestions
    static func capitalSuggestions(for query: String, in mode: GameMode) -> [String] {
        let normalizedQuery = normalize(query)
        guard !normalizedQuery.isEmpty else { return [] }

        // Pool of all unique primary capitals so suggestions are comprehensive
        let sourceItems = allItems
        var uniqueCapitals = Set<String>()
        for item in sourceItems {
            uniqueCapitals.insert(item.capital)
        }

        let sortedCapitals = Array(uniqueCapitals).sorted()

        var prefixMatches: [String] = []
        var containsMatches: [String] = []

        for cap in sortedCapitals {
            let normCap = normalize(cap)
            if normCap.hasPrefix(normalizedQuery) {
                prefixMatches.append(cap)
            } else if normalizedQuery.count >= 2 && normCap.contains(normalizedQuery) {
                containsMatches.append(cap)
            }
        }

        return Array((prefixMatches + containsMatches).prefix(8))
    }
}
