import { Component, Inject, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Subject, takeUntil } from 'rxjs';
import { ProcessTypeService } from '../process-type.service';
import { ProcessType } from '../process-type.types';
import { ModalSelectProcessTypeService } from './modal-select-process-type.service';

@Component({
  selector: 'app-modal-select-process-type',
  templateUrl: './modal-select-process-type.component.html',
})
export class ModalSelectProcessTypeComponent implements OnInit {
  id_process_type: string = '';

  private _unsubscribeAll: Subject<any> = new Subject<any>();

  listProcessType: ProcessType[] = [];
  selectProcessTypeForm!: FormGroup;

  constructor(
    @Inject(MAT_DIALOG_DATA) public _data: any,
    private _formBuilder: FormBuilder,
    private _processTypeService: ProcessTypeService,
    private _modalSelectProcessTypeService: ModalSelectProcessTypeService
  ) {}

  ngOnInit(): void {
    /**
     * get the list of processType
     */
    this._processTypeService
      .queryRead('*')
      .pipe(takeUntil(this._unsubscribeAll))
      .subscribe((_processTypes: ProcessType[]) => {
        this.listProcessType = _processTypes;
      });
    /**
     * form
     */
    this.selectProcessTypeForm = this._formBuilder.group({
      id_process_type: ['', [Validators.required]],
    });
  }
  /**
   * patchForm
   */
  patchForm(): void {
    this.selectProcessTypeForm.patchValue({
      id_process_type: this.selectProcessTypeForm.getRawValue().id_process_type,
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
    this.id_process_type =
      this.selectProcessTypeForm.getRawValue().id_process_type;
    this.patchForm();
  }
  /**
   * closeModalSelectProcessType
   */
  closeModalSelectProcessType(): void {
    this._modalSelectProcessTypeService.closeModalSelectProcessType();
  }
}
