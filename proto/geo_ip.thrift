include "base.thrift"
namespace java com.rbkmoney.damsel.geo_ip

/**
* IPv4 или IPv6 адрес
**/
typedef string IpAdress
/**
* Идентификатор места по базе http://www.geonames.org/
**/
typedef i32 GeoId

struct LocationInfo {
    // geoId города
    1: required GeoId cityGeoId;
    // geoId региона
    2: optional GeoId subdivision1GeoId;
    3: optional GeoId subdivision2GeoId;
    // geoId страны
    4: required GeoId countryGeoId;
    // Полное описание локации в json
    // полное описание на сайте https://www.maxmind.com/en/geoip2-city
    7: required string rawResponse;
}

struct GeoIdInfo{
   1: required GeoId geonameId;
   2: string localeCode;
   3: string continentCode;
   4: string continentName;
   5: string countryIsoCode;
   6: string countryName;
   7: optional string subdivision_1IsoCode;
   8: optional string subdivision_1Name;
   9: optional string subdivision_2IsoCode;
   10: optional string subdivision_2Name;
   11: optional string cityName;
   12: optional string metroCode;
   13: optional string timeZone;
}


/** Исключение, сигнализирующее о том, что невозможно определить местоположение по указанному IP */
exception CantDetermineLocation {}
/** Исключение, сигнализирующее о том, что в базе нет описания для указанных geoId */
exception GeoIdNotFound {
    1: list<GeoId> geoIds
}

/**
* Интерфейс Geo Service для клиентов.
*/
service GeoIpService {
    /**
    * Возвращает информацию о предполагаемом местоположении по IP
    **/
    map <IpAdress,LocationInfo> GetLocation(1: set<IpAdress> ip) throws (1: CantDetermineLocation ex1)
    /**
     * Возвращает текстовое описание места на указанном языке
     * geoIds - список geo-id по которым нужно получить информацию.
     * lang - язык ответа. Например: "RU", "ENG"
     **/
    set <GeoIdInfo> GetLocationInfo ( 1: set<GeoId> geoIds, 2:String lang) throws (1: GeoIdNotFound ex1)
}