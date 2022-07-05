import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { ProcessService } from '../process.service';
import { Process } from '../process.types';
import { ModalSelectProcessService } from './modal-select-process.service';

@Component({
  selector: 'app-modal-select-process',
  templateUrl: './modal-select-process.component.html',
})
export class ModalSelectProcessComponent implements OnInit {
  id_process: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listProcess: Process[] = [];
  selectProcessForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _processService: ProcessService,
    private _modalSelectProcessService: ModalSelectProcessService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of process
     */
    this._processService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_processs: Process[]) => {
        this.listProcess = _processs;
      });
    /**
     * form
     */
    this.selectProcessForm = this._formBuilder.group({
      id_process: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectProcessForm.patchValue({
      id_process: this.selectProcessForm.getRawValue().id_process,
    });
  }
  /**
   * On destroy
   */
  ngOnDestroy(): void {
    /**
     * Unsubscribe from all subscriptions
     */
    this._unsubscribeAll.next(0);
    this._unsubscribeAll.complete();
  }
  /**
   * changeSelect
   */
  changeSelect(): void {
    this.id_process = this.selectProcessForm.getRawValue().id_process;
    this.patchForm();
  }
  /**
   * closeModalSelectProcess
   */
  closeModalSelectProcess(): void {
    this._modalSelectProcessService.closeModalSelectProcess();
  }
}
