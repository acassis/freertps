#ifndef FREERTPS_PUB_H
#define FREERTPS_PUB_H

#include "freertps/udp.h"
#include "freertps/id.h"
#include <stdint.h>

typedef struct
{
  const char           *topic_name;
  const char           *type_name;
  frudp_eid_t           writer_id;
  frudp_sn_t            max_tx_sn_avail;
  frudp_sn_t            min_tx_sn_avail;
  uint32_t              num_data_submsgs;
  frudp_submsg_data_t **data_submsgs;
  uint32_t              next_submsg_idx;
  frudp_sn_t            next_sn;
} frudp_pub_t;

frudp_pub_t *frudp_create_pub(const char *topic_name,
                              const char *type_name,
                              const frudp_eid_t writer_id,
                              frudp_submsg_data_t **data_submsgs,
                              const uint32_t num_data_submsgs);

void frudp_publish(frudp_pub_t *publication, 
                   frudp_submsg_data_t *submsg);

frudp_pub_t *frudp_pub_from_writer_id(const frudp_eid_t id);

void frudp_pub_rx_acknack(frudp_pub_t *pub,
                          frudp_submsg_acknack_t *acknack,
                          frudp_guid_prefix_t *guid_prefix);

frudp_pub_t *frudp_create_user_pub(const char *topic_name,
                                   const char *type_name);

#endif
