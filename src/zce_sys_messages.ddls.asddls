@EndUserText.label: 'Custom Entity: Backend System Messages'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CE_SYS_MESSAGES'
define custom entity Zce_Sys_Messages
{
  key sys_message : abap.string(0);  
}
