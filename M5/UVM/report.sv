`include "uvm_macros.svh"
import uvm_pkg::*;

class my_report_server extends uvm_report_server;

  int log_fd;

  function new();
    super.new();
    log_fd = $fopen("uvm_log.txt", "w");
    if (log_fd == 0)
      `uvm_fatal("LOG", "Failed to open log file")
  endfunction

  virtual function void report(
    uvm_severity severity,
    string name,
    string id,
    string message,
    int verbosity_level,
    string filename,
    int line,
    uvm_report_object client
  );

    string sev_str, border;

    case (severity)
      UVM_INFO:    sev_str = "INFO ";
      UVM_WARNING: sev_str = "WARN ";
      UVM_ERROR:   sev_str = "ERROR";
      UVM_FATAL:   sev_str = "FATAL";
      default:     sev_str = "UNKWN";
    endcase

    // Optional visual separator for FAIL cases
    if (severity inside {UVM_ERROR, UVM_FATAL}) begin
      border = "==================== FAIL ====================";
      $fdisplay(log_fd, "\n%s", border);
    end

    $fdisplay(log_fd,
      "[%s] %-10s | %-20s | %-25s | %s",
      sev_str, id, name, filename, message
    );

    if (severity inside {UVM_ERROR, UVM_FATAL}) begin
      $fdisplay(log_fd, "%s\n", border);
    end

    // Also optionally display on terminal
    super.report(severity, name, id, message, verbosity_level, filename, line, client);

  endfunction

endclass
