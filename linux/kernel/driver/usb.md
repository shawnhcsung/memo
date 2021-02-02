# USB

```text
[  550.861315] ********
[  550.861367] shawn: dwc3_thread_interrupt(): irq = 1036
[  550.861417] shawn: dwc3_process_event_buf(): left = 8
[  550.861423] ======== loop: 1
[  550.861429] shawn: dwc3_process_event_buf(): left = 8
[  550.861438] shawn: dwc3_process_event_entry(): ep irq
[  550.861444] shawn: dwc3_endpoint_interrupt(ep0out): ep0 or ep1
[  550.861453] shawn: dwc3_ep0_interrupt(ep0out): ep0out: Transfer Complete: 'Setup Phase'
[  550.861459] shawn: dwc3_ep0_xfer_complete(ep0out): setup phase
[  550.861674] ======== loop: 2
[  550.861681] shawn: dwc3_process_event_buf(): left = 4
[  550.861688] shawn: dwc3_process_event_entry(): ep irq
[  550.861695] shawn: dwc3_endpoint_interrupt(ep0out): ep0 or ep1
[  550.861704] shawn: dwc3_ep0_interrupt(ep0out): ep0out: Transfer Not Ready (Not Active): 'Setup Phase'
[  550.861713] shawn: dwc3_ep0_xfernotready(ep0out): data: ignored
[  550.863914] --> shawn: uvc_v4l2_ioctl_default(): send response
[  550.863937] shawn: dwc3_gadget_ep0_queue(ep0out)
[  550.863969] shawn: dwc3_ep0_prepare_one_trb(ep0out)
[  550.863972] shawn: dwc3_ep0_start_trans(ep0out)
[  550.864237] ********
[  550.864292] shawn: dwc3_thread_interrupt(): irq = 1036
[  550.864344] shawn: dwc3_process_event_buf(): left = 8
[  550.864351] ======== loop: 1
[  550.864357] shawn: dwc3_process_event_buf(): left = 8
[  550.864366] shawn: dwc3_process_event_entry(): ep irq
[  550.864373] shawn: dwc3_endpoint_interrupt(ep0out): ep0 or ep1
[  550.864383] shawn: dwc3_ep0_interrupt(ep0out): ep0out: Transfer Complete: 'Data Phase'
[  550.864390] shawn: dwc3_ep0_xfer_complete(ep0out): data phase
[  550.864398] shawn: dwc3_ep0_complete_data()
[  550.864409] shawn: dwc3_gadget_giveback(ep0out)
[  550.864422] shawn: usb_gadget_giveback_request(ep0out)
[  550.864534] ======== loop: 2
[  550.864541] shawn: dwc3_process_event_buf(): left = 4
[  550.864548] shawn: dwc3_process_event_entry(): ep irq
[  550.864555] shawn: dwc3_endpoint_interrupt(ep0in): ep0 or ep1
[  550.864565] shawn: dwc3_ep0_interrupt(ep0in): ep0in: Transfer Not Ready (Not Active): 'Data Phase'
[  550.864572] shawn: dwc3_ep0_xfernotready(ep0in): status
[  550.864579] shawn: dwc3_ep0_prepare_one_trb(ep0in)
[  550.864585] shawn: dwc3_ep0_start_trans(ep0in)
```

- interrupt
- endpoints
- phases: setup, data, status
  - transfer complete ? not ready ? not active?
