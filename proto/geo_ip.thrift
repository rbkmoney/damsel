include "base.thrift"
include "domain.thrift"

namespace java com.rbkmoney.damsel.geo_ip

/**
* Идентификатор места по базе http://www.geonames.org/
**/
typedef i32 GeoID

struct LocationInfo {
    // GeoID города
    1: required GeoID cityGeoID;
    // GeoID региона
    2: optional GeoID subdivision1GeoID;
    3: optional GeoID subdivision2GeoID;
    // GeoID страны
    4: required GeoID countryGeoID;
    // Полное описание локации в json
    // полное описание на сайте https://www.maxmind.com/en/geoip2-city
    7: required string rawResponse;
}

struct SubdivisionInfo{
        // глубина в иерархии. Чем ниже тем цифра выше. Например 1 - Московская область. 2 - Подольский район.
       1: required i16 level
       2: optional string subdivisionIsoCode;
       3: optional string subdivisionName;
}

// информация о данном GeoID
struct GeoIDInfo{
   1: required GeoID geonameId;
   2: string localeCode;
   3: string continentCode;
   4: string continentName;
   5: string countryIsoCode;
   6: string countryName;
   7: set<SubdivisionInfo> subdivisions;
   8: optional string cityName;
   9: optional string metroCode;
   10: optional string timeZone;
}


/** Исключение, сигнализирующее о том, что невозможно определить местоположение по указанному IP */
exception CantDetermineLocation {}
/** Исключение, сигнализирующее о том, что в базе нет описания для указанных GeoID */
exception GeoIDNotFound {
    1: list<GeoID> geoIDs
}

/**
* Интерфейс Geo Service для клиентов - "Columbus"
*/
service GeoIpService {
    /**
    * Возвращает информацию о предполагаемом местоположении по IP
    **/
    map <domain.IPAddress,LocationInfo> GetLocation(1: set<domain.IPAddress> ip) throws (1: CantDetermineLocation ex1)
    /**
     * Возвращает текстовое описание места на указанном языке
     * GeoIDs - список geo-id по которым нужно получить информацию.
     * lang - язык ответа. Например: "RU", "ENG"
     **/
    set <GeoIDInfo> GetLocationInfo (1: set<GeoID> geoIDs, 2: string lang) throws (1: GeoIDNotFound ex1)
}