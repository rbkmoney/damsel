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

enum Lang{
    ENG,
    RU
}

struct LocationInfo {
    // geoId города
    1: optional GeoId cityGeoId;
    // geoId региона
    2: optional GeoId subdivision1GeoId;
    3: optional GeoId subdivision2GeoId;
    // geoId страны
    4: optional GeoId countryGeoId;
    // Долгота
    5: optional double longitude
    // Широта
    6: optional double latitude;
    // Полное описание локации в json
    // полное описание на сайте https://www.maxmind.com/en/geoip2-city
    7: string rawResponse;
}

struct GeoIdInfo{
   1: GeoId geonameId;
   2: string localeCode;
   3: string continentCode;
   4: string continentName;
   5: string countryIsoCode;
   6: string countryName;
   7: string subdivision_1IsoCode;
   8: string subdivision_1Name;
   9: string subdivision_2IsoCode;
   10: string subdivision_2Name;
   11: string cityName;
   12: string metroCode;
   13: string timeZone;
}


/** Исключение, сигнализирующее о том, что невозможно определить местоположение по указанному IP */
exception GeoIp2Exception {}
/** Исключение, сигнализирующее о том, что в базе нет описания для указанных geoId */
exception GeoIpNotFoundException {
    1: list<GeoId> geoIds
}

/**
* Интерфейс Geo Service для клиентов.
*/
service GeoIpService {
    /**
    * Возвращает информацию о предполагаемом местоположении по IP
    **/
    map <IpAdress,LocationInfo> GetLocation(1:IpAdress ip) throws (1:GeoIp2Exception ex1)
    /**
     * Возвращает текстовое описание места на указанном языке
     **/
    map <GeoId,GeoIdInfo> GetLocationInfo(1: set<GeoId> geoIds, 2: Lang lang) throws (1:GeoIpNotFoundException ex1)

}